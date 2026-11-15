#!/bin/bash
# Usage: ./generate_epoch_coin.sh <epoch_number> <silver|gold> [theme]
# Themes: forest desert beach ocean mountain night aurora lagoon meadow savanna reef storm bloodmoon
#         sunrise lighthouse balloons windmill sailboat sunflower train (random if omitted)

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

THEMES=(forest desert beach ocean mountain night aurora lagoon meadow savanna reef storm bloodmoon sunrise lighthouse balloons windmill sailboat sunflower train)
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
  bloodmoon)
    BG=(-size 200x200 xc:"#1a0f26"
      -fill "#0b0614" -draw "rectangle 0,0 200,40"
      -fill "#130a20" -draw "rectangle 0,40 200,70"
      -fill "#2e1636" -draw "rectangle 0,100 200,152"
      -fill "#8e1216" -draw "circle 178,22 178,50"
      -fill "#6e0d11" -draw "circle 168,14 168,19" -draw "circle 190,32 190,36" -draw "circle 176,38 176,41"
      -fill "#d8d0e0" -draw "point 14,10" -draw "point 30,24" -draw "point 8,34"
      -fill "#0e0812" -draw "rectangle 0,152 200,200"
      -fill "#08050b" -draw "rectangle 0,176 200,200"
      -fill "#030204" -draw "rectangle 10,118 12,152" -draw "polygon 11,128 2,116 3,115 12,126" -draw "polygon 11,136 20,122 21,123 12,138" -draw "polygon 11,144 1,136 2,135 12,142"
      -draw "rectangle 186,122 188,152" -draw "polygon 187,132 196,118 197,119 188,134" -draw "polygon 187,140 178,128 177,129 186,142" -draw "polygon 187,146 198,140 198,142 188,148") ;;
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
  sunrise)
    BG=(-size 200x200 xc:"#b7a3d6"
      -fill "#6b8fc9" -draw "rectangle 0,0 200,30"
      -fill "#9198d2" -draw "rectangle 0,30 200,60"
      -fill "#f6b8a8" -draw "rectangle 0,100 200,128"
      -fill "#ffd59a" -draw "rectangle 0,128 200,148"
      -fill "#fff0b5" -draw "circle 22,148 22,132"
      -fill "#f4ecef" -draw "rectangle 0,146 200,150"
      -fill "#6f8f5a" -draw "path 'M 0,152 Q 50,140 100,154 T 200,150 L 200,200 L 0,200 Z'"
      -fill "#607f4f" -draw "path 'M 0,164 Q 40,156 90,166 T 200,160 L 200,200 L 0,200 Z'"
      -fill "#4f7044" -draw "path 'M 0,180 Q 60,170 110,182 T 200,176 L 200,200 L 0,200 Z'"
      -fill "#43623b" -draw "path 'M 0,192 Q 70,186 120,194 T 200,190 L 200,200 L 0,200 Z'"
      -fill "#3f5f38" -draw "rectangle 8,182 9,185" -draw "rectangle 20,188 21,191" -draw "rectangle 34,184 35,187" -draw "rectangle 168,180 169,183" -draw "rectangle 182,186 183,189" -draw "rectangle 194,178 195,181"
      -fill "#f6d6e0" -draw "point 14,170" -draw "point 28,176" -draw "point 176,168" -draw "point 190,172"
      -fill "#3a2f4a" -draw "line 162,20 166,24" -draw "line 166,24 170,20" -draw "line 176,32 179,35" -draw "line 179,35 182,32") ;;
  lighthouse)
    BG=(-size 200x200 xc:"#2b3f66"
      -fill "#1d2b4a" -draw "rectangle 0,0 200,45"
      -fill "#4a5a82" -draw "rectangle 0,100 200,124"
      -fill "#e9a46b" -draw "rectangle 0,124 200,140"
      -fill "#1f4f73" -draw "rectangle 0,140 200,200"
      -fill "#2a6690" -draw "rectangle 0,160 200,200"
      -fill "#245d84" -draw "path 'M 0,168 Q 25,163 50,168 T 100,168 T 150,168 T 200,168 L 200,174 L 0,174 Z'"
      -fill "#33739e" -draw "path 'M 0,184 Q 25,179 50,184 T 100,184 T 150,184 T 200,184 L 200,188 L 0,188 Z'"
      -fill "#cfe6f2" -draw "rectangle 6,152 20,153" -draw "rectangle 22,178 36,179" -draw "rectangle 8,192 18,193" -draw "rectangle 150,186 162,187"
      -fill "#fff2b0" -draw "polygon 186,104 200,82 200,96"
      -fill "#33333a" -draw "polygon 168,200 172,168 186,160 200,166 200,200"
      -fill "#45454e" -draw "polygon 172,168 186,160 182,172 174,176"
      -fill "#e8f4fa" -draw "point 166,184" -draw "point 164,190" -draw "point 167,196" -draw "point 170,178"
      -fill "#f2f2f2" -draw "polygon 180,164 182,112 190,112 192,164"
      -fill "#d9363e" -draw "rectangle 181,126 191,134" -draw "rectangle 180,146 192,154"
      -fill "#2a2a30" -draw "rectangle 180,104 192,112"
      -fill "#ffe066" -draw "rectangle 183,106 189,111"
      -fill "#2a2a30" -draw "polygon 179,104 186,97 193,104"
      -fill white -draw "point 22,16" -draw "point 40,30" -draw "point 12,46") ;;
  balloons)
    BG=(-size 200x200 xc:"#cfe8f7"
      -fill "#eef8fd" -draw "rectangle 0,0 200,28"
      -fill "#def1fa" -draw "rectangle 0,28 200,55"
      -fill "#e8434a" -draw "ellipse 26,28 11,13 0,360"
      -fill "#ffd34a" -draw "rectangle 20,16 24,40" -draw "rectangle 28,16 32,40"
      -fill "#5a4030" -draw "rectangle 23,44 29,48"
      -fill "#3a2a20" -draw "line 18,36 23,44" -draw "line 34,36 29,44"
      -fill "#4a8fe0" -draw "ellipse 180,44 8,9 0,360"
      -fill white -draw "rectangle 178,35 182,53"
      -fill "#5a4030" -draw "rectangle 178,55 182,58"
      -fill "#ff9f43" -draw "ellipse 188,14 5,6 0,360"
      -fill "#5a4030" -draw "rectangle 187,21 189,23"
      -fill "#8fc46a" -draw "path 'M 0,160 Q 50,146 100,162 T 200,156 L 200,200 L 0,200 Z'"
      -fill "#7fb85e" -draw "path 'M 0,170 Q 50,162 100,172 T 200,166 L 200,200 L 0,200 Z'"
      -fill "#6faa52" -draw "path 'M 0,184 Q 60,174 110,186 T 200,180 L 200,200 L 0,200 Z'"
      -fill "#e2d6a8" -draw "path 'M 0,196 Q 40,190 80,194 T 160,192 T 200,190 L 200,193 Q 160,195 120,196 T 40,198 T 0,199 Z'"
      -fill "#3f6b2a" -draw "circle 14,172 14,166" -draw "circle 188,168 188,162"
      -fill "#5a4030" -draw "rectangle 13,176 15,182" -draw "rectangle 187,172 189,178"
      -fill "#5a9442" -draw "rectangle 28,178 29,181" -draw "rectangle 40,184 41,187" -draw "rectangle 160,182 161,185" -draw "rectangle 172,176 173,179") ;;
  windmill)
    BG=(-size 200x200 xc:"#7ab4e6"
      -fill "#3f86d0" -draw "rectangle 0,0 200,24"
      -fill "#5a9ddc" -draw "rectangle 0,24 200,52"
      -fill "#a8d0f0" -draw "rectangle 0,120 200,150"
      -fill "#c8d6e6" -draw "circle 20,34 20,22" -draw "circle 38,30 38,16" -draw "circle 4,40 4,30" -draw "rectangle 0,34 54,46"
      -fill white -draw "circle 20,30 20,19" -draw "circle 38,26 38,14" -draw "circle 4,36 4,27" -draw "rectangle 0,30 52,40"
      -fill "#c8d6e6" -draw "circle 172,22 172,12" -draw "circle 188,18 188,6" -draw "rectangle 158,22 200,32"
      -fill white -draw "circle 172,19 172,10" -draw "circle 188,15 188,5" -draw "rectangle 160,19 200,28"
      -fill "#e6f2fb" -draw "rectangle 2,86 20,87" -draw "rectangle 8,96 24,97" -draw "rectangle 178,74 196,75" -draw "rectangle 2,112 14,113"
      -fill "#8fbf5a" -draw "rectangle 0,150 200,200"
      -fill "#83b553" -draw "path 'M 0,162 Q 50,154 100,164 T 200,158 L 200,200 L 0,200 Z'"
      -fill "#76a849" -draw "path 'M 0,176 Q 60,168 110,178 T 200,172 L 200,200 L 0,200 Z'"
      -fill "#6a9a42" -draw "path 'M 0,188 Q 70,182 120,190 T 200,186 L 200,200 L 0,200 Z'"
      -fill "#c9b48a" -draw "polygon 185,165 189,165 172,200 160,200"
      -fill "#5f8f3a" -draw "rectangle 10,170 11,173" -draw "rectangle 24,180 25,183" -draw "rectangle 40,192 41,195" -draw "rectangle 150,184 151,187" -draw "rectangle 196,176 197,179" -draw "rectangle 140,196 141,199"
      -fill "#7a5a44" -draw "polygon 178,165 181,114 193,114 196,165"
      -fill "#4a3a2e" -draw "polygon 178,114 187,104 196,114"
      -fill "#2a2a30" -draw "rectangle 184,150 190,165"
      -stroke "#f2f2f2" -strokewidth 3 -draw "line 187,110 203,94" -draw "line 187,110 171,126" -draw "line 187,110 171,94" -draw "line 187,110 203,126" -stroke none
      -fill "#4a3a2e" -draw "circle 187,110 187,108") ;;
  sailboat)
    BG=(-size 200x200 xc:"#c9b8d8"
      -fill "#7fa6d6" -draw "rectangle 0,0 200,30"
      -fill "#a7b4dc" -draw "rectangle 0,30 200,60"
      -fill "#f2c79a" -draw "rectangle 0,100 200,118"
      -fill "#f8a978" -draw "rectangle 0,118 200,132"
      -fill "#fff0b5" -draw "circle 24,24 24,12"
      -fill "#2f6f9a" -draw "rectangle 0,132 200,200"
      -fill "#2b6890" -draw "path 'M 0,148 Q 25,143 50,148 T 100,148 T 150,148 T 200,148 L 200,152 L 0,152 Z'"
      -fill "#285f86" -draw "rectangle 0,162 200,200"
      -fill "#225576" -draw "path 'M 0,178 Q 25,173 50,178 T 100,178 T 150,178 T 200,178 L 200,182 L 0,182 Z'"
      -fill "#3a7aa6" -draw "rectangle 30,160 40,161" -draw "rectangle 140,170 150,171" -draw "rectangle 20,186 30,187"
      -fill "#ffd59a" -draw "rectangle 8,140 26,141" -draw "rectangle 12,150 30,151" -draw "rectangle 6,170 20,171" -draw "rectangle 150,192 164,193"
      -fill "#f2f2f2" -draw "polygon 180,140 180,174 197,174" -draw "polygon 177,148 177,174 164,174"
      -fill "#3a2a20" -draw "rectangle 178,138 179,178"
      -fill "#5a3a28" -draw "polygon 160,178 198,178 192,187 166,187"
      -fill "#1f4f70" -draw "rectangle 162,190 196,191"
      -fill "#3a2f4a" -draw "line 160,18 164,22" -draw "line 164,22 168,18") ;;
  sunflower)
    BG=(-size 200x200 xc:"#9fd0f0"
      -fill "#dff0fb" -draw "rectangle 0,0 200,28"
      -fill "#bfe2f6" -draw "rectangle 0,28 200,55"
      -fill "#fff0b5" -draw "circle 176,24 176,12"
      -fill "#7fb84a" -draw "rectangle 0,150 200,200"
      -fill "#70aa42" -draw "path 'M 0,164 Q 50,156 100,166 T 200,160 L 200,200 L 0,200 Z'"
      -fill "#5f9a3a" -draw "path 'M 0,180 Q 60,172 110,182 T 200,176 L 200,200 L 0,200 Z'"
      -fill "#548a33" -draw "path 'M 0,192 Q 70,187 120,194 T 200,190 L 200,200 L 0,200 Z'"
      -fill "#4a7f2c" -draw "rectangle 18,186 19,189" -draw "rectangle 40,180 41,183" -draw "rectangle 156,182 157,185" -draw "rectangle 180,190 181,193" -draw "rectangle 4,174 5,177"
      -fill "#3f7a2a" -draw "rectangle 9,160 11,200" -draw "rectangle 29,170 31,200" -draw "rectangle 169,166 171,200" -draw "rectangle 189,158 191,200"
      -fill "#ffc72c" -draw "circle 10,156 10,147" -draw "circle 30,166 30,158" -draw "circle 170,162 170,154" -draw "circle 190,154 190,145"
      -fill "#6a3f1f" -draw "circle 10,156 10,152" -draw "circle 30,166 30,163" -draw "circle 170,162 170,159" -draw "circle 190,154 190,150"
      -fill "#ffc72c" -draw "point 50,190" -draw "point 60,186" -draw "point 140,188" -draw "point 150,192") ;;
  train)
    BG=(-size 200x200 xc:"#bfe3f5"
      -fill "#e8f6fc" -draw "rectangle 0,0 200,28"
      -fill "#d3eef8" -draw "rectangle 0,28 200,55"
      -fill "#8fc46a" -draw "path 'M 0,150 Q 50,136 100,152 T 200,146 L 200,200 L 0,200 Z'"
      -fill "#7db85c" -draw "path 'M 0,166 Q 50,158 100,168 T 200,162 L 200,200 L 0,200 Z'"
      -fill "#6faa52" -draw "rectangle 0,180 200,200"
      -fill "#5a9a42" -draw "circle 30,178 30,173" -draw "circle 40,180 40,176" -draw "circle 132,180 132,176"
      -fill "#a89a80" -draw "rectangle 0,190 200,198"
      -fill "#5a4030" -draw "rectangle 0,192 200,194"
      -fill "#8a7a6a" -draw "rectangle 4,194 8,196" -draw "rectangle 20,194 24,196" -draw "rectangle 36,194 40,196" -draw "rectangle 160,194 164,196" -draw "rectangle 176,194 180,196" -draw "rectangle 192,194 196,196"
      -fill "#e8434a" -draw "rectangle 150,174 176,188"
      -fill "#2a2a30" -draw "rectangle 160,166 164,174" -draw "rectangle 168,170 176,174"
      -fill "#ffd34a" -draw "rectangle 152,176 158,182"
      -fill "#4a8fe0" -draw "rectangle 178,176 200,188"
      -fill "#2a2a30" -draw "circle 156,190 156,187" -draw "circle 170,190 170,187" -draw "circle 184,190 184,187" -draw "circle 196,190 196,187"
      -fill "#f2f2f2" -draw "circle 162,158 162,154" -draw "circle 156,148 156,143" -draw "circle 148,138 148,132") ;;
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
