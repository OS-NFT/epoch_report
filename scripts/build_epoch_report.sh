#!/usr/bin/env bash
# build_epoch_report.sh - Epoch Report v2 metadata, sourced from Koios.
#
#   build_epoch_report.sh <epoch> --theme <theme> --cid <ipfs-cid> [-o <file>]
#   build_epoch_report.sh --regress            # rebuild 654-656 and compare to ~/epoch-report-NNN-metadata.v2.json
#
# Rules (Sept 28 spec):
#   buckets  new=proposed in N; active=proposed before N and unresolved through N;
#            ratified/enacted/expired = that event in N
#   order    oldest proposal first (block_time, proposal_index)
#   titles   on-chain meta title, trimmed, one trailing period removed, then chunk64
#   votes    strings, keys drep, cc, spo - each only if that body votes on the action type (CIP-1694);
#            spo on ParameterChange only when a security-group parameter changes
#   checks   no string > 64 bytes, no nulls, cardano-cli build-raw dry run
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHUNK="$DIR/chunk64.jq"
KOIOS="${KOIOS:-https://api.koios.rest/api/v1}"
POLICY="f8b9cb66507bb95a96dc7523ecfe15fd7e5b4f24297e36553fd93c1d"
ADDR_FILE="${ADDR_FILE:-/opt/cardano/cnode/priv/wallet/epoch_report/base.addr}"
WORK="$(mktemp -d)"; trap 'rm -rf "$WORK"' EXIT

log() { echo "  $*" >&2; }
die() { echo "ERROR: $*" >&2; exit 1; }
[[ -f "$CHUNK" ]] || die "chunk64.jq not found next to this script ($CHUNK)"

tier_for() {  # gold: sequential run (either direction), round hundred, or repdigit
  local n="$1" d up=1 down=1 same=1 i
  d=$(echo "$n" | sed 's/./& /g')
  read -ra a <<<"$d"
  for ((i = 1; i < ${#a[@]}; i++)); do
    (( a[i] == a[i-1] + 1 )) || up=0
    (( a[i] == a[i-1] - 1 )) || down=0
    (( a[i] == a[i-1] )) || same=0
  done
  if (( up || down || same || n % 100 == 0 )); then echo gold; else echo silver; fi
}

fetch_proposals() {  # all proposals, paged, cached for this run
  local out="$WORK/proposals.json" off=0 page
  echo "[]" >"$out"
  while :; do
    page=$(curl -sf "$KOIOS/proposal_list?select=proposal_id,proposal_type,block_time,proposal_index,proposed_epoch,ratified_epoch,enacted_epoch,dropped_epoch,expired_epoch,title:meta_json->body->>title,param_proposal&order=block_time.asc&offset=$off&limit=1000") \
      || die "Koios proposal_list request failed"
    jq -s '.[0] + .[1]' "$out" <(echo "$page") >"$out.tmp" && mv "$out.tmp" "$out"
    (( $(echo "$page" | jq length) < 1000 )) && break
    off=$((off + 1000))
  done
  echo "$out"
}

votes_for() {  # voting summary for one proposal, cached
  local id="$1" f="$WORK/vote_$1.json"
  [[ -f "$f" ]] || curl -sf "$KOIOS/proposal_voting_summary?_proposal_id=$id" | jq '.[0]' >"$f" \
    || die "Koios voting summary failed for $id"
  cat "$f"
}

build() {  # build <epoch> <theme> <cid> <outfile>
  local n="$1" theme="$2" cid="$3" out="$4" props tier
  props=$(fetch_proposals)
  tier=$(tier_for "$n")

  # Votes for every proposal resolved in N
  local ids
  ids=$(jq -r --argjson n "$n" '.[] | select(.ratified_epoch == $n or .enacted_epoch == $n or .expired_epoch == $n) | .proposal_id' "$props")
  echo "{}" >"$WORK/votes.json"
  for id in $ids; do
    jq --arg id "$id" --argjson v "$(votes_for "$id")" '. + {($id): $v}' "$WORK/votes.json" >"$WORK/v.tmp" && mv "$WORK/v.tmp" "$WORK/votes.json"
  done

  jq --argjson n "$n" --arg theme "$theme" --arg cid "$cid" --arg tier "$tier" --arg policy "$POLICY" \
     --slurpfile votes "$WORK/votes.json" -f /dev/stdin "$props" >"$WORK/raw.json" <<'JQ'
def security_keys: [
  "max_block_size","max_tx_size","max_bh_size","max_val_size","max_block_ex_mem","max_block_ex_steps",
  "min_fee_a","min_fee_b","coins_per_utxo_size","gov_action_deposit","min_fee_ref_script_cost_per_byte",
  "maxBlockBodySize","maxTxSize","maxBlockHeaderSize","maxValueSize","maxBlockExecutionUnits",
  "txFeePerByte","txFeeFixed","utxoCostPerByte","govActionDeposit","minFeeRefScriptCostPerByte"];
def changed_keys: (.param_proposal // {}) | if type == "object" then [to_entries[] | select(.value != null) | .key] else [] end;
def spo_votes:
  if .proposal_type | IN("NoConfidence","NewCommittee","HardForkInitiation","InfoAction") then true
  elif .proposal_type == "ParameterChange" then (changed_keys | any(IN(security_keys[])))
  else false end;
def cc_votes: (.proposal_type | IN("NoConfidence","NewCommittee")) | not;
def clean_title: (.title // ("UNTITLED " + .proposal_id)) | gsub("^\\s+|\\s+$"; "") | sub("\\.$"; "");
def item($with_votes):
  { title: clean_title, type: .proposal_type }
  + if $with_votes then
      ($votes[0][.proposal_id]) as $v
      | { votes: ({ drep: ($v.drep_yes_pct | tostring) }
                  + (if cc_votes then { cc: ($v.committee_yes_pct | tostring) } else {} end)
                  + (if spo_votes then { spo: ($v.pool_yes_pct | tostring) } else {} end)) }
    else {} end;
def open_through($n): (.ratified_epoch == null or .ratified_epoch > $n)
                      and (.expired_epoch == null or .expired_epoch > $n)
                      and (.dropped_epoch == null or .dropped_epoch > $n)
                      and (.enacted_epoch == null or .enacted_epoch > $n);
sort_by(.block_time, .proposal_index) as $p
| { "721": { ($policy): { ("EpochReport\($n)"): {
      name: "Epoch Report \($n)",
      image: "ipfs://\($cid)",
      mediaType: "image/png",
      tier: $tier,
      theme: $theme,
      epoch: $n,
      governance: {
        new:      [$p[] | select(.proposed_epoch == $n) | item(false)],
        active:   [$p[] | select(.proposed_epoch < $n and open_through($n)) | item(false)],
        ratified: [$p[] | select(.ratified_epoch == $n) | item(true)],
        enacted:  [$p[] | select(.enacted_epoch == $n)  | item(true)],
        expired:  [$p[] | select(.expired_epoch == $n)  | item(true)]
      } } } } }
JQ

  jq -f "$CHUNK" "$WORK/raw.json" >"$out"

  # ---- review log -------------------------------------------------------
  log "Epoch $n  tier=$tier  theme=$theme"
  jq -r --argjson n "$n" '
    sort_by(.block_time, .proposal_index)[]
    | (if .proposed_epoch == $n then "new" elif .ratified_epoch == $n then "ratified" elif .enacted_epoch == $n then "enacted"
       elif .expired_epoch == $n then "expired" elif .dropped_epoch == $n and .expired_epoch == null and .ratified_epoch == null then "DROPPED (not in schema)" else empty end) as $b
    | "  \($b): \(.proposal_type)  \(.title // "NO TITLE")"
      + (if .proposal_type == "ParameterChange" then "  params=\([(.param_proposal // {}) | objects | to_entries[] | select(.value != null) | .key] | join(","))" else "" end)' \
    "$props" >&2
  grep -q '"UNTITLED ' "$out" && log "WARNING: an action has no on-chain title - set it by hand before minting"

  # ---- checks -----------------------------------------------------------
  local long nulls
  long=$(jq '[.. | strings | select(utf8bytelength > 64)] | length' "$out")
  nulls=$(jq '[.. | select(. == null)] | length' "$out")
  (( long == 0 )) || die "$long string(s) over 64 bytes in $out"
  (( nulls == 0 )) || die "$nulls null value(s) in $out"
  if command -v cardano-cli >/dev/null && [[ -f "$ADDR_FILE" ]]; then
    cardano-cli latest transaction build-raw \
      --tx-in "0000000000000000000000000000000000000000000000000000000000000000#0" \
      --tx-out "$(cat "$ADDR_FILE")+2000000" --fee 0 \
      --metadata-json-file "$out" --out-file "$WORK/check.raw" \
      && log "build-raw dry run: OK" || die "build-raw rejected the metadata"
  else
    log "build-raw dry run skipped (cardano-cli or $ADDR_FILE not found)"
  fi
  log "wrote $out"
}

regress() {
  local n fx out rc=0
  for n in 654 655 656; do
    fx="$HOME/epoch-report-$n-metadata.v2.json"
    [[ -f "$fx" ]] || { echo "SKIP $n: $fx not found"; continue; }
    local theme cid
    theme=$(jq -r '.["721"][][].theme' "$fx")
    cid=$(jq -r '.["721"][][].image | if type == "array" then join("") else . end | sub("^ipfs://"; "")' "$fx")
    out="$WORK/regress-$n.json"
    build "$n" "$theme" "$cid" "$out" 2>"$WORK/log-$n.txt" || { echo "FAIL $n: build error"; cat "$WORK/log-$n.txt"; rc=1; continue; }
    if cmp -s "$out" "$fx"; then
      echo "PASS $n: byte-identical to $fx"
    elif diff <(jq -S . "$out") <(jq -S . "$fx") >/dev/null; then
      echo "NEAR $n: same content, different formatting"; rc=1
    elif diff <(jq -S '.["721"][][].governance |= map_values(sort_by(.title | if type == "array" then join("") else . end))' "$out") \
              <(jq -S '.["721"][][].governance |= map_values(sort_by(.title | if type == "array" then join("") else . end))' "$fx") >/dev/null; then
      echo "PASS* $n: same content; legacy item order differs (chain order from 657)"
    else
      echo "FAIL $n: content differs (built < > minted):"; diff <(jq . "$out") <(jq . "$fx") || true; rc=1
    fi
  done
  return $rc
}

# ---- args -----------------------------------------------------------------
if [[ "${1:-}" == "--regress" ]]; then regress; exit $?; fi
[[ "${1:-}" =~ ^[0-9]+$ ]] || die "usage: $0 <epoch> --theme <theme> --cid <cid> [-o file]  |  $0 --regress"
EPOCH="$1"; shift
THEME="" CID="" OUT=""
while (( $# )); do
  case "$1" in
    --theme) THEME="$2"; shift 2 ;;
    --cid)   CID="$2"; shift 2 ;;
    -o)      OUT="$2"; shift 2 ;;
    *) die "unknown option $1" ;;
  esac
done
[[ -n "$THEME" && -n "$CID" ]] || die "--theme and --cid are required"
build "$EPOCH" "$THEME" "$CID" "${OUT:-$HOME/epoch-report-$EPOCH-metadata.json}"
