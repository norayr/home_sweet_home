LUT="dehancer-fuji-provia-100f.png"
FLUT="${LUT%.*}"
CODEC="-codec:v libx264 -codec:a copy"
FN="${1%.*}"
#ffmpeg -i $1  -vf lut3d="$LUT" $CODEC ${FN}_eterna.mp4
ffmpeg -i $1  -vf  "movie=${LUT}, [in] haldclut" $CODEC ${FN}_${FLUT}.mp4

