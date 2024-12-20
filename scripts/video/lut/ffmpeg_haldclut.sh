LUT="fujichrome-astia-100-daylight.png"
#LUT="fujichrome-provia-100f.png"
#LUT="fujichrome-sensia-400-exp-2011.png"
#LUT="fujichrome-velvia-50.png"
FLUT="${LUT%.*}"
#CODEC="-codec:v libx264 -codec:a copy"
CODEC="-c:v libx264 -preset slow -crf 22 -b:v 2000k -c:a aac -b:a 320k"
FN="${1%.*}"
#ffmpeg -i $1  -vf lut3d="$LUT" $CODEC ${FN}_eterna.mp4
ffmpeg -i $1  -vf  "movie=${LUT}, [in] haldclut" $CODEC ${FN}_${FLUT}.mp4
