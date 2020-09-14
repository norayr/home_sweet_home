#auto levels, rotation, color correction
AL='-vf "pp=al"'
ROT='-vf "hflip,vflip,format=yuv420p  -metadata:s:v rotate=0"'
COL='-vf "eq=contrast=1.5:brightness=-0.05:saturation=0.3"'
#ffmpeg -i 20180915_235930.mp4  -vf "pp=al"  -vf "hflip,vflip,format=yuv420p"  -vf "eq=contrast=1.5:brightness=-0.05:saturation=0.3"  -metadata:s:v rotate=0 -codec:v libx264 -codec:a copy out1.mkv
LUT="Fujifilm_Eterna_Vivid_160T_(8543)_-_Look.cube"
FN="${1%.*}"
ffmpeg -i $1 $AL $ROT $COL -codec:v libx264 -codec:a copy ${FN}_fix.mp4
