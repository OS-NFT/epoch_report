def toks: split(" ") | . as $a | [range(0; length) as $i | if $i < (length - 1) then $a[$i] + " " else $a[$i] end];
def chunk64:
  if type == "string" and utf8bytelength > 64 then
    if startswith("ipfs://") then ["ipfs://", .[7:]]
    else reduce toks[] as $t ([""]; if ((.[length-1] + $t) | utf8bytelength) <= 64 then .[length-1] += $t else . + [$t] end)
    end
  else . end;
walk(chunk64)
