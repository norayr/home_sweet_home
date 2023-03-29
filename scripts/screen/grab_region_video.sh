ffmpeg -f x11grab -framerate 25 -video_size 1100x700 -i :0.0+0,100 -b:v 11M /tmp/out.mpg
