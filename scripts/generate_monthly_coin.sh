#!/bin/bash
# Usage: ./generate_monthly_coin.sh <YYYY-MM>
# Monthly Report image, same pixel style as generate_epoch_coin.sh:
# 200x200 canvas, +antialias, flat colour bands, one point-filter upscale to 800x800.
#   - A large unrolled Roman scroll carrying the month's calendar
#   - Red marks on the days an epoch boundary falls (21:44:51 UTC)
#   - Background: layered colour bands, colour family set by the season

YM="$1"
if [[ ! "$YM" =~ ^[0-9]{4}-(0[1-9]|1[0-2])$ ]]; then
  echo "Usage: $0 <YYYY-MM>"
  exit 1
fi
YEAR="${YM%-*}"; MON="${YM#*-}"

# Background bands by season, light (top) -> dark (bottom); tops kept mid-tone
case "$MON" in
  12) TOP="9098b8"; BOT="262b45" ;;  # winter: slate night
  01) TOP="8aa4c6"; BOT="1e3557" ;;  # winter: deep blue
  02) TOP="9aaec6"; BOT="34475f" ;;  # winter: steel
  03) TOP="9cc48e"; BOT="3a6331" ;;  # spring: early green
  04) TOP="8cc488"; BOT="2c6638" ;;  # spring: green
  05) TOP="7eb882"; BOT="22573a" ;;  # spring: deep green
  06) TOP="d6c673"; BOT="8a7a22" ;;  # summer: sunlit wheat
  07) TOP="dbb862"; BOT="94661a" ;;  # summer: gold
  08) TOP="d6a858"; BOT="8c5718" ;;  # summer: late amber
  09) TOP="d6955d"; BOT="87401b" ;;  # autumn: harvest rust
  10) TOP="cc7e52"; BOT="702914" ;;  # autumn: brick
  11) TOP="b8906d"; BOT="553724" ;;  # autumn: walnut
esac

# ---- Calendar + epoch facts (UTC) ----
first_ts=$(date -u -d "${YM}-01 00:00:00" +%s)
next_ts=$(date -u -d "${YM}-01 +1 month" +%s)
last_ts=$((next_ts - 1))
days=$(( (next_ts - first_ts) / 86400 ))
dow=$(date -u -d "${YM}-01" +%w)
rows=$(( (dow + days + 6) / 7 ))
MON_NAME=$(date -u -d "${YM}-01" +%B | tr '[:lower:]' '[:upper:]')

ANCHOR_E=659; ANCHOR_TS=$(date -u -d "2026-10-01 21:44:51" +%s); LEN=432000
epoch_at() { local d=$(( $1 - ANCHOR_TS )); echo $(( ANCHOR_E + (d >= 0 ? d / LEN : -((-d + LEN - 1) / LEN)) )); }
E_FIRST=$(epoch_at "$first_ts"); E_LAST=$(epoch_at "$last_ts")
bdays=()
for (( e = E_FIRST + 1; e <= E_LAST; e++ )); do
  bdays+=( "$(date -u -d "@$(( ANCHOR_TS + (e - ANCHOR_E) * LEN ))" +%-d)" )
done

# ---- Background: 8 flat bands stepping from TOP to BOT ----
BG=(-size 200x200 xc:"#$TOP")
for (( b = 0; b < 8; b++ )); do
  col="#"
  for j in 0 2 4; do
    a=$(( 16#${TOP:$j:2} )); z=$(( 16#${BOT:$j:2} ))
    col+=$(printf "%02x" $(( a + ((z - a) * b * 2 + 7) / 14 )))
  done
  BG+=(-fill "$col" -draw "rectangle 0,$(( b*25 )) 200,$(( b*25 + 24 ))")
done

# ---- Scroll ----
PX0=34; PX1=166; PY0=24; PY1=178          # parchment
INK="#6b4a22"; RULE="#8a6a3a"; KNOB="#5a3312"
SCROLL=(
  -fill "#00000040" -draw "rectangle $((PX0+3)),$((PY0+3)) $((PX1+3)),$((PY1+4))"   # drop shadow
  -fill "#f2e3b5" -draw "rectangle $PX0,$PY0 $PX1,$PY1"
  -fill "#e9d6a0" -draw "rectangle $PX0,$PY0 $PX1,$((PY0+4))"
  -fill "#e9d6a0" -draw "rectangle $PX0,$((PY1-22)) $PX1,$PY1"
  # rolled ends (cylinders) with light / dark faces
  -fill "#d9bf85" -draw "rectangle $((PX0-10)),$((PY0-4)) $PX0,$((PY1+4))"
  -fill "#ecd8a6" -draw "rectangle $((PX0-8)),$((PY0-4)) $((PX0-5)),$((PY1+4))"
  -fill "#a8844c" -draw "rectangle $((PX0-1)),$((PY0-4)) $PX0,$((PY1+4))"
  -fill "#d9bf85" -draw "rectangle $PX1,$((PY0-4)) $((PX1+10)),$((PY1+4))"
  -fill "#ecd8a6" -draw "rectangle $((PX1+2)),$((PY0-4)) $((PX1+5)),$((PY1+4))"
  -fill "#a8844c" -draw "rectangle $((PX1+9)),$((PY0-4)) $((PX1+10)),$((PY1+4))"
  # rod knobs
  -fill "$KNOB" -draw "rectangle $((PX0-8)),$((PY0-9)) $((PX0-2)),$((PY0-4))"
  -draw "rectangle $((PX0-8)),$((PY1+4)) $((PX0-2)),$((PY1+9))"
  -draw "rectangle $((PX1+2)),$((PY0-9)) $((PX1+8)),$((PY0-4))"
  -draw "rectangle $((PX1+2)),$((PY1+4)) $((PX1+8)),$((PY1+9))"
  # rule under the title
  -fill "$RULE" -draw "rectangle $((PX0+10)),72 $((PX1-10)),72"
)

# ---- Calendar grid (compact) ----
CW=16; GX=$(( 100 - 7*CW/2 )); GY=92; CH=$(( 60 / rows ))
GRID=(-fill none -stroke "$RULE" -strokewidth 1)
for (( r = 0; r <= rows; r++ )); do
  y=$(( GY + r*CH )); GRID+=(-draw "line $GX,$y $((GX + 7*CW)),$y")
done
for (( c = 0; c <= 7; c++ )); do
  x=$(( GX + c*CW )); GRID+=(-draw "line $x,$GY $x,$((GY + rows*CH))")
done
WD=(S M T W T F S)
HEAD=(-stroke none -fill "$INK" -font Nimbus-Roman-Bold -pointsize 12 -gravity NorthWest)
for c in 0 1 2 3 4 5 6; do
  HEAD+=(-annotate +$(( GX + c*CW + 4 ))+$(( GY - 15 )) "${WD[$c]}")
done
# Boundary days: whole cell in Roman red with the day number; other days: a dot
MARKS=(-stroke none -fill "#a3271f")
NUMS=(-stroke none -fill "#f7ebc6" -font Nimbus-Roman-Bold -pointsize 10 -gravity NorthWest)
DOTS=(-stroke none -fill "#b8955a")
for (( d = 1; d <= days; d++ )); do
  i=$(( dow + d - 1 )); r=$(( i / 7 )); c=$(( i % 7 ))
  hit=0; for b in "${bdays[@]}"; do [ "$b" -eq "$d" ] && hit=1; done
  x=$(( GX + c*CW )); y=$(( GY + r*CH ))
  if [ $hit -eq 1 ]; then
    MARKS+=(-draw "rectangle $((x + 1)),$((y + 1)) $((x + CW - 1)),$((y + CH - 1))")
    off=$(( d < 10 ? 5 : 2 ))
    NUMS+=(-annotate +$(( x + off ))+$(( y + (CH - 10) / 2 )) "$d")
  else
    DOTS+=(-draw "rectangle $((x + 7)),$((y + CH/2 - 1)) $((x + 8)),$((y + CH/2))")
  fi
done

# Title size fits the month name
TPS=$(( 180 / ${#MON_NAME} )); (( TPS > 24 )) && TPS=24

convert "${BG[@]}" \
  +antialias \
  "${SCROLL[@]}" \
  "${GRID[@]}" \
  "${DOTS[@]}" \
  "${MARKS[@]}" \
  "${HEAD[@]}" \
  "${NUMS[@]}" \
  -gravity North \
  -fill "#c9ab73" -font Nimbus-Roman-Bold -pointsize $TPS -annotate +1+27 "$MON_NAME" \
  -fill "#1a1a1a" -font Nimbus-Roman-Bold -pointsize $TPS -annotate +0+26 "$MON_NAME" \
  -fill "$INK"    -font Nimbus-Roman-Bold -pointsize 16 -annotate +0+53 "$YEAR" \
  -gravity South \
  -fill "$INK"    -font Nimbus-Roman-Bold -pointsize 13 -annotate +0+$(( 200 - PY1 + 4 )) "EPOCHS ${E_FIRST}-${E_LAST}" \
  -filter point -resize 800x800 \
  "monthly_${YM}_coin.png"

echo "Generated monthly_${YM}_coin.png (epochs ${E_FIRST}-${E_LAST}, boundaries on days: ${bdays[*]})"
