#!/bin/bash
# Usage: ./generate_epoch_coin.sh <epoch_number> <silver|gold> [theme]
# Themes: forest desert beach ocean mountain night aurora lagoon meadow savanna reef storm (random if omitted)

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

THEMES=(forest desert beach ocean mountain night aurora lagoon meadow savanna reef storm)
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
  aurora)
    BG=(-size 200x200 xc:"#071a2b"
      -fill "#0b2440" -draw "rectangle 0,100 200,150"
      -fill "#2ecc71" -draw "path 'M 0,40 Q 50,20 100,45 T 200,35 L 200,48 Q 150,58 100,58 T 0,52 Z'"
      -fill "#1abc9c" -draw "path 'M 0,62 Q 60,45 110,68 T 200,60 L 200,70 Q 150,80 100,78 T 0,72 Z'"
      -fill "#8e44ad" -draw "path 'M 0,80 Q 70,70 120,86 T 200,82 L 200,88 Q 150,94 100,92 T 0,86 Z'"
      -fill "#e8f1f8" -draw "rectangle 0,160 200,200"
      -fill "#d2dfea" -draw "rectangle 0,182 200,200"
      -fill "#0b1f17" -draw "polygon 6,165 16,128 26,165"
      -fill "#0b1f17" -draw "polygon 174,165 184,128 194,165"
      -fill white -draw "point 25,15" -draw "point 170,12" -draw "point 190,95" -draw "point 12,110") ;;
  lagoon)
    BG=(-size 200x200 xc:"#140d33"
      -fill "#241650" -draw "rectangle 0,55 200,95"
      -fill "#4a2a7a" -draw "rectangle 0,95 200,118"
      -fill "#fff6c8" -draw "circle 28,28 28,14"
      -fill "#063f47" -draw "rectangle 0,118 200,200"
      -fill "#0a5a63" -draw "rectangle 0,140 200,200"
      -fill "#39ffe0" -draw "rectangle 0,128 200,130" -draw "rectangle 0,152 200,155" -draw "rectangle 0,172 200,175"
      -fill "#f2deb0" -draw "rectangle 0,186 200,200"
      -fill "#e2c890" -draw "rectangle 0,194 200,200"
      -fill white -draw "point 60,12" -draw "point 150,20" -draw "point 185,45" -draw "point 12,70" -draw "point 190,85") ;;
  meadow)
    BG=(-size 200x200 xc:"#cfe9f5"
      -fill "#eef8fc" -draw "rectangle 0,0 200,25"
      -fill "#def1f8" -draw "rectangle 0,25 200,50"
      -fill white -draw "rectangle 8,22 38,28" -draw "rectangle 14,18 32,22"
      -fill white -draw "rectangle 158,12 190,18" -draw "rectangle 166,8 182,12"
      -fill "#9fd25a" -draw "path 'M 0,140 Q 50,122 100,138 T 200,132 L 200,200 L 0,200 Z'"
      -fill "#83bf3f" -draw "path 'M 0,162 Q 60,148 110,162 T 200,158 L 200,200 L 0,200 Z'"
      -fill "#6aa832" -draw "rectangle 0,184 200,200"
      -fill "#ff8fb1" -draw "point 14,176" -draw "point 40,190" -draw "point 168,174" -draw "point 186,192"
      -fill "#ffe34d" -draw "point 26,186" -draw "point 176,184" -draw "point 8,194" -draw "point 194,170") ;;
  savanna)
    BG=(-size 200x200 xc:"#f7d083"
      -fill "#fbe7b4" -draw "rectangle 0,0 200,30"
      -fill "#f9dc9c" -draw "rectangle 0,30 200,60"
      -fill "#f4b860" -draw "rectangle 0,110 200,150"
      -fill "#f08a3a" -draw "circle 184,150 184,134"
      -fill "#c9a24a" -draw "rectangle 0,150 200,200"
      -fill "#b38a3a" -draw "rectangle 0,170 200,200"
      -fill "#9c7530" -draw "rectangle 0,188 200,200"
      -fill "#3b2a1a" -draw "rectangle 15,160 18,186"
      -fill "#3b2a1a" -draw "polygon 2,160 8,152 26,152 32,160"
      -fill "#3b2a1a" -draw "line 16,170 9,161" -draw "line 17,168 25,161") ;;
  reef)
    BG=(-size 200x200 xc:"#0f6e8c"
      -fill "#3fb3cf" -draw "rectangle 0,0 200,20"
      -fill "#2a98b8" -draw "rectangle 0,20 200,45"
      -fill "#1c84a3" -draw "rectangle 0,45 200,70"
      -fill "#2c8fae" -draw "polygon 6,0 18,0 34,40 22,40" -draw "polygon 182,0 194,0 178,40 166,40"
      -fill "#e6d3a3" -draw "rectangle 0,182 200,200"
      -fill "#d6c08a" -draw "rectangle 0,192 200,200"
      -fill "#ff6f61" -draw "rectangle 10,150 14,184" -draw "rectangle 4,160 8,176" -draw "rectangle 16,158 20,172"
      -fill "#ff9f43" -draw "circle 32,176 32,168"
      -fill "#c44569" -draw "rectangle 180,148 184,184" -draw "rectangle 186,160 190,176" -draw "rectangle 174,162 178,174"
      -fill "#ffd166" -draw "circle 166,178 166,171"
      -fill white -draw "point 12,96" -draw "point 15,86" -draw "point 186,120" -draw "point 189,110") ;;
  storm)
    BG=(-size 200x200 xc:"#3b4552"
      -fill "#2a313b" -draw "rectangle 0,0 200,40"
      -fill "#333b47" -draw "rectangle 0,40 200,70"
      -fill "#46515f" -draw "rectangle 0,100 200,130"
      -fill "#fff7b0" -draw "polygon 184,4 172,30 180,30 170,54 192,22 184,22 194,4"
      -fill "#1d2a33" -draw "rectangle 0,130 200,200"
      -fill "#24343f" -draw "rectangle 0,152 200,200"
      -fill "#2b3d4a" -draw "rectangle 0,176 200,200"
      -fill "#8fa3b0" -draw "rectangle 8,150 22,152" -draw "rectangle 168,160 184,162" -draw "rectangle 176,182 192,184" -draw "rectangle 24,186 38,188") ;;
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
