#ffmpeg -f x11grab -r 25 -s 1920x1080 -i :0.0 /tmp/output.mpg
#ffmpeg -f oss -i /dev/audio -f x11grab -s 1920x1080 -r 3 -ab 11 -i :0.0 /tmp/out.mp4
#ffmpeg -y -f x11grab -draw_mouse 1 -framerate 25 -video_size 1920x1080 -i :0.0 -f alsa -i hw:1,0 -c:v libx264 -pix_fmt yuv420p -b:v 2500k -c:a aac -strict -2 -b:a 192k -movflags +faststart /tmp/output.mp4
#ffmpeg -y -f x11grab -draw_mouse 1 -framerate 25 -video_size 1024x768 -i :0.0 -f alsa -i hw:1,0 -c:v libx264 -pix_fmt yuv420p -b:v 2500k -c:a aac -strict -2 -b:a 192k -movflags +faststart /tmp/output.mp4

ffmpeg -y -f x11grab -draw_mouse 1 -framerate 10 -video_size 1024x768 -i :0.0 -pix_fmt yuv420p -b:v 2500k  /tmp/output.mp4

ffmpeg -f alsa -i hw:1 out.wav
#ffmpeg -video_size 1024x768 -framerate 25 -f x11grab -i :0.0+100,200 -f alsa -ac 2 -i hw:0 output.mkv
