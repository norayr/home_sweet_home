# i get audio from jack. you may want something else.
# i get video from x11. you may want something else.
KEY=YOUR_STREAM_KEY
ffmpeg \
-f x11grab -r 30 -s 1920x1080 -i :0.0+0,0 \
-f jack -i ffmpeg \
-c:v libx264 -preset ultrafast -c:a aac \
-f flv "rtmp://toobnix.org:1935/live/${KEY}" | grep -v rtmp

