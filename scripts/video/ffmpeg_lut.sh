LUT="Fujifilm_Eterna_Vivid_160T_(8543)_-_Look.cube"
CODEC="-codec:v libx264 -codec:a copy"
FN="${1%.*}"
ffmpeg -i $1  -vf lut3d="$LUT" $CODEC ${FN}_eterna.mp4

