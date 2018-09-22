#pp=al auto levels
# hflim flip
#eq

ffmpeg -i $1  -vf "pp=al"  -vf "hflip,vflip,format=yuv420p"  -vf "eq=contrast=1.5:brightness=-0.05:saturation=0.3"  -metadata:s:v rotate=0 -codec:v libx264 -codec:a copy $1.mkv
