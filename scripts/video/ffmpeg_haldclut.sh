set -x
LUTPATH="/amp/env/lut/dhnc"
LUT="fujichrome-provia-100f.png"
LUTWITHPATH="${LUTPATH}/${LUT}"
FLUT="${LUT%.*}"
CODEC="-codec:v libx264 -codec:a copy"
FN="${1%.*}"
#ffmpeg -i $1  -vf lut3d="$LUTWITHPATH" $CODEC ${FN}_eterna.mp4

#ROT="-vf transpose=2"
#0 = 90CounterCLockwise and Vertical Flip (default)
#1 = 90Clockwise
#2 = 90CounterClockwise
#3 = 90Clockwise and Vertical Flip




ffmpeg -i $1 -vf "movie=${LUT}, [in] haldclut" -vf "transpose=2" $CODEC ${FN}_${FLUT}.mp4

