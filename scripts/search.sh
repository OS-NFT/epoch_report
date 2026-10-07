#!/usr/bin/env bash
# search.sh - search minted report metadata (Epoch Reports v1 + v2, Monthly Reports)
# Usage: scripts/search.sh [term]   (no term = list every governance item)
# Rules: string arrays are joined with "" (CIP-25 chunking);
#        votes read from v2 `votes{}` or v1 `*_yes_pct` fields;
#        each report is matched to manifest.json by asset name.
set -euo pipefail
cd "$(dirname "$0")/.."
jq -r --arg q "${1:-}" --slurpfile m manifest.json '
  def j: if type == "array" then join("") else . end;
  ."721" | to_entries[] | select(.value | type == "object") | .value
  | to_entries[] | .key as $asset | .value as $a
  | ([$m[0].reports[] | select(.asset == $asset) | .tx] | first // "") as $tx
  | ($a.epoch // $a.month // $asset | tostring) as $label
  | ($a.governance // {}) | to_entries[] | select(.value | type == "array")
  | .key as $s | .value[]
  | (.title | j) as $t
  | (.type // "-") as $ty
  | (.votes // (with_entries(select(.key | endswith("_yes_pct")))
               | with_entries(.key |= sub("_yes_pct$"; "")))) as $v
  | select($q == "" or ([$t, $ty, $s] | any(ascii_downcase | contains($q | ascii_downcase))))
  | [$label, $s, $ty, $t,
     ($v | to_entries | map("\(.key)=\(.value)") | join(" ") | if . == "" then "-" else . end),
     (if $tx == "" then "-" else $tx[0:12] end)] | @tsv
' metadata/*.json | column -t -s $'\t'
