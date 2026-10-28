#!/bin/bash
# Usage: ./generate_epoch_hand.sh <epoch_number> [theme]
# Simple pixel-art hand on the 200x200 grid (same as the coin series), scaled up 4x.
# Left hand turned palm-up, seen by its owner from above (fingers away, thumb on the left).
# The hand is drawn on its own layer; the digits are drawn on top exactly as on the coins.
# Digits are drawn exactly as on the silver coins (shadow #4d4d4d at +2+2, fill #1a1a1a).
EPOCH="$1"; THEME="${2:-beach}"
FONT="${FONT:-Nimbus-Roman-Bold}"
[ -z "$EPOCH" ] && { echo "Usage: $0 <epoch> [theme]"; exit 1; }
SKIN="#f1e7cf"; INK="#1d1814"

case "$THEME" in
  beach)
    BG=(-size 200x200 xc:"#bfe6f0"
      -fill "#eafafd" -draw "rectangle 0,0 200,25"
      -fill "#d8f2f7" -draw "rectangle 0,25 200,50"
      -fill "#f2e2b8" -draw "rectangle 0,150 200,200"
      -fill "#e8d29c" -draw "rectangle 0,178 200,200"
      -fill "#6fbcda" -draw "rectangle 0,128 200,142"
      -fill "#4fa8cc" -draw "rectangle 0,142 200,148"
      -fill "#2a7fa8" -draw "rectangle 0,148 200,155"
      -fill "#f7d33c" -draw "circle 20,20 20,5") ;;
  *) echo "Draft supports beach only"; exit 1 ;;
esac

T=$(mktemp -d)
# Hand silhouette. Fingers are drawn 1px narrower than their spacing so a thin
# gap (which becomes an ink line) separates them above the palm.
convert -size 200x200 xc:black +antialias -fill white -stroke white \
  -strokewidth 19 -draw "stroke-linecap round line 65,84 63,56"   -strokewidth 16 -draw "stroke-linecap round line 63,56 61,36" \
  -strokewidth 20 -draw "stroke-linecap round line 87,82 87,50"   -strokewidth 17 -draw "stroke-linecap round line 87,50 87,26" \
  -strokewidth 19 -draw "stroke-linecap round line 109,84 110,54" -strokewidth 16 -draw "stroke-linecap round line 110,54 111,32" \
  -strokewidth 15 -draw "stroke-linecap round line 129,88 132,68" -strokewidth 13 -draw "stroke-linecap round line 132,68 134,52" \
  -stroke none \
  -draw "path 'M 56,80 Q 96,72 138,84 Q 148,104 145,124 Q 142,146 128,160 L 125,176 Q 100,181 77,176 L 74,162 Q 58,150 56,128 Z'" \
  -draw "ellipse 65,128 15,22 0,360" \
  -stroke white -strokewidth 24 -draw "stroke-linecap round line 60,124 50,108" \
  -strokewidth 19 -draw "stroke-linecap round line 50,108 41,93" \
  -strokewidth 15 -draw "stroke-linecap round line 41,93 34,81" -stroke none \
  "$T/mask.png"

# Gaps between fingers: carve 1px lines from each fingertip gap down to the webbing.
convert "$T/mask.png" +antialias -stroke black -strokewidth 1 \
  -draw "line 75,82 75,54" -draw "line 98,82 98,50" -draw "line 120,86 121,66" \
  "$T/mask.png"

# Outline = 1px ring just outside the silhouette, plus the carved gaps.
convert "$T/mask.png" -morphology EdgeOut Diamond:1 "$T/edge.png"
convert -size 200x200 xc:none +antialias -stroke "$INK" -strokewidth 1 \
  -draw "line 75,82 75,54" -draw "line 98,82 98,50" -draw "line 120,86 121,66" "$T/gaps.png"

# Hand layer: fill, outline, gaps and creases.
convert -size 200x200 xc:none \
  \( "$T/mask.png" -alpha copy -fill "$SKIN" -colorize 100 \) -composite \
  \( "$T/edge.png" -alpha copy -fill "$INK" -colorize 100 \) -composite \
  "$T/gaps.png" -composite \
  +antialias -stroke "$INK" -strokewidth 1 -fill none \
  -draw "line 59,44 65,44" -draw "line 83,34 91,34" -draw "line 106,40 114,40" -draw "line 130,57 136,57" \
  -draw "line 57,58 67,58" -draw "line 58,60 66,60" -draw "line 81,50 93,50" -draw "line 82,52 92,52" \
  -draw "line 104,54 116,54" -draw "line 105,56 115,56" -draw "line 128,68 137,68" -draw "line 129,70 136,70" \
  -draw "line 58,74 69,74" -draw "line 81,70 93,70" -draw "line 104,72 116,72" -draw "line 127,79 137,79" \
  -draw "line 34,97 48,89" -draw "line 35,100 49,92" -draw "line 45,115 57,108" \
  -draw "path 'M 59,110 Q 54,132 67,152'" \
  -draw "path 'M 84,132 Q 110,128 136,134'" \
  "$T/hand.png"

convert "${BG[@]}" "$T/hand.png" -composite +antialias \
  -stroke none -fill "#4d4d4d" -font "$FONT" -pointsize 55 -gravity center -annotate +2+2 "$EPOCH" \
  -stroke none -fill "#1a1a1a" -font "$FONT" -pointsize 55 -gravity center -annotate +0+0 "$EPOCH" \
  -filter point -resize 800x800 "epoch_${EPOCH}_hand.png"

rm -rf "$T"
echo "Generated epoch_${EPOCH}_hand.png (theme: $THEME)"
