#!/usr/bin/env bash
# search.sh - search minted Epoch Report metadata (v1 + v2 schemas)
# Usage: scripts/search.sh [term]   (no term = list every governance item)
# Rules: string arrays are joined with "" (CIP-25 chunking);
#        votes read from v2 `votes{}` or v1 `*_yes_pct` fields.
set -euo pipefail
cd "$(dirname "$0")/.."
jq -r --arg q "${1:-}" --slurpfile m manifest.json '
  ."721"[][] as $a
  | ($m[0].reports[] | select(.epoch == $a.epoch) | .tx) as $tx
  | $a.governance | to_entries[] | .key as $s | .value[]
  | (.title | if type == "array" then join("") else . end) as $t
  | (.votes // (with_entries(select(.key | endswith("_yes_pct")))
               | with_entries(.key |= sub("_yes_pct$"; "")))) as $v
  | select($q == "" or ([$t, .type, $s] | any(ascii_downcase | contains($q | ascii_downcase))))
  | [$a.epoch, $s, .type, $t,
     ($v | to_entries | map("\(.key)=\(.value)") | join(" ") | if . == "" then "-" else . end),
     $tx[0:12]] | @tsv
' metadata/*.json | column -t -s $'\t'
