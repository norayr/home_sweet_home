#ffmpeg -f x11grab -framerate 25 -video_size 100x130 -i :0.0+0,460 out2.mpg
ffmpeg -f x11grab -framerate 25 -video_size 1280x800 -i :0.0+0,290 /tmp/out.mp4
