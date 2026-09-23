#!/bin/bash
# Usage: ./generate_epoch_coin.sh <epoch_number> <silver|gold> [theme]
# Themes: forest desert beach ocean mountain night (random if omitted)

EPOCH="$1"
TIER="$2"
THEME="$3"

if [ -z "$EPOCH" ] || [ -z "$TIER" ]; then
  echo "Usage: $0 <epoch_number> <silver|gold> [theme]"
  exit 1
fi

if [ "$TIER" == "gold" ]; then
  FILL="#d4af37"
  STROKE="#7a5c00"
  HIGHLIGHT="#f2d879"
else
  FILL="#c0c0c0"
  STROKE="#4d4d4d"
  HIGHLIGHT="#e8e8e8"
fi

THEMES=(forest desert beach ocean mountain night)
if [ -z "$THEME" ]; then
  THEME=${THEMES[$RANDOM % ${#THEMES[@]}]}
fi

case "$THEME" in
  forest)
    BG=(-size 200x200 xc:"#a8d5a0"
      -fill "#dcf2d5" -draw "rectangle 0,0 200,30"
      -fill "#c3e8bb" -draw "rectangle 0,30 200,55"
      -fill "#4a7c3f" -draw "rectangle 0,150 200,200"
      -fill "#3f6d35" -draw "rectangle 0,168 200,200"
      -fill "#3a6030" -draw "rectangle 0,185 200,200"
      -fill "#1f4d3d" -draw "polygon 4,197 15,160 26,197"
      -fill "#163a2d" -draw "polygon 9,168 15,145 21,168"
      -fill "#1f4d3d" -draw "polygon 24,197 35,165 46,197"
      -fill "#163a2d" -draw "polygon 29,173 35,150 41,173"
      -fill "#1f4d3d" -draw "polygon 154,197 165,165 176,197"
      -fill "#163a2d" -draw "polygon 159,173 165,150 171,173"
      -fill "#1f4d3d" -draw "polygon 174,197 185,160 196,197"
      -fill "#163a2d" -draw "polygon 179,168 185,145 191,168"
      -fill "#5c3a21" -draw "rectangle 13,190 17,200"
      -fill "#5c3a21" -draw "rectangle 33,190 37,200"
      -fill "#5c3a21" -draw "rectangle 163,190 167,200"
      -fill "#5c3a21" -draw "rectangle 183,190 187,200") ;;
  desert)
    BG=(-size 200x200 xc:"#f0d896"
      -fill "#fcf0c8" -draw "rectangle 0,0 200,25"
      -fill "#f7e6b0" -draw "rectangle 0,25 200,55"
      -fill "#d9a441" -draw "rectangle 0,150 200,200"
      -fill "#c69135" -draw "rectangle 0,168 200,200"
      -fill "#b3781f" -draw "rectangle 0,185 200,200"
      -fill "#8b3a1f" -draw "polygon 150,195 172,138 172,195"
      -fill "#d4652f" -draw "polygon 172,195 172,138 195,195"
      -fill "#f7d33c" -draw "circle 175,25 175,10") ;;
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
  ocean)
    BG=(-size 200x200 xc:"#0e3d5c"
      -fill "#164e73" -draw "rectangle 0,0 200,90"
      -fill "#1a5f8a" -draw "path 'M 0,130 Q 50,110 100,130 T 200,130 L 200,200 L 0,200 Z'"
      -fill "#2e88b8" -draw "path 'M 0,160 Q 50,140 100,160 T 200,160 L 200,200 L 0,200 Z'"
      -fill "#3fa3d4" -draw "path 'M 0,180 Q 50,168 100,180 T 200,180 L 200,200 L 0,200 Z'") ;;
  mountain)
    BG=(-size 200x200 xc:"#3d2b56"
      -fill "#5e3d68" -draw "rectangle 0,70 200,120"
      -fill "#8c4a6e" -draw "rectangle 0,120 200,155"
      -fill "#c96b7a" -draw "rectangle 0,155 200,175"
      -fill "#e8956b" -draw "rectangle 0,175 200,200"
      -fill "#3d2b56" -draw "polygon 0,200 18,128 58,200"
      -fill white -draw "polygon 13,148 18,128 28,148"
      -fill "#4e3d70" -draw "polygon 42,200 63,160 84,200"
      -fill white -draw "polygon 57,175 63,160 70,175"
      -fill "#5f4a86" -draw "polygon 70,200 92,150 114,200"
      -fill white -draw "polygon 86,167 92,150 99,167"
      -fill "#71589c" -draw "polygon 96,200 118,162 140,200"
      -fill white -draw "polygon 112,177 118,162 125,177"
      -fill "#8467b2" -draw "polygon 120,200 143,155 166,200"
      -fill white -draw "polygon 137,172 143,155 150,172"
      -fill "#9a79c8" -draw "polygon 143,200 185,128 200,200"
      -fill white -draw "polygon 178,147 185,128 190,147") ;;
  night)
    BG=(-size 200x200 xc:"#0a0e2e"
      -fill "#111539" -draw "rectangle 0,100 200,140"
      -fill "#151a3d" -draw "rectangle 0,140 200,170"
      -fill "#1c2247" -draw "rectangle 0,170 200,200"
      -fill "#f5f0c8" -draw "circle 170,30 170,15"
      -fill white -draw "point 20,20" -draw "point 195,60" -draw "point 20,180" -draw "point 180,180") ;;
  *)
    echo "Unknown theme: $THEME"; exit 1 ;;
esac

# Reeded (milled) edge — 24 tick marks, inward-only from the rim (radius 75) to radius 65
TICKS=()
for i in $(seq 0 15 345); do
  read x1 y1 x2 y2 < <(awk -v a="$i" 'BEGIN{
    pi=3.14159265358979; rad=a*pi/180;
    printf "%.1f %.1f %.1f %.1f", 100+75*cos(rad), 100+75*sin(rad), 100+65*cos(rad), 100+65*sin(rad)
  }')
  TICKS+=(-draw "line $x1,$y1 $x2,$y2")
done

# Gold-only shiny digit outline
DIGIT_OUTLINE=()
if [ "$TIER" == "gold" ]; then
  DIGIT_OUTLINE=(-stroke "$HIGHLIGHT" -strokewidth 2 -fill none -font Nimbus-Roman-Bold -pointsize 55 -gravity center -annotate +0+0 "$EPOCH")
fi

convert "${BG[@]}" \
  +antialias \
  -fill "$FILL" -stroke "$STROKE" -strokewidth 4 -draw "circle 100,100 100,25" \
  -fill none -stroke "$STROKE" -strokewidth 1 -draw "circle 100,100 100,23" \
  -fill none -stroke "$STROKE" -strokewidth 2 -draw "circle 100,100 100,38" \
  -stroke "$STROKE" -strokewidth 2 "${TICKS[@]}" \
  -fill none -stroke "$HIGHLIGHT" -strokewidth 3 -draw "arc 35,35 165,165 200,260" \
  -stroke none -fill "$STROKE" -font Nimbus-Roman-Bold -pointsize 55 -gravity center -annotate +2+2 "$EPOCH" \
  "${DIGIT_OUTLINE[@]}" \
  -stroke none -fill "#1a1a1a" -font Nimbus-Roman-Bold -pointsize 55 -gravity center -annotate +0+0 "$EPOCH" \
  -filter point -resize 800x800 \
  "epoch_${EPOCH}_coin.png"

echo "Generated epoch_${EPOCH}_coin.png (theme: $THEME, tier: $TIER)"
