ffmpeg -y -f x11grab -draw_mouse 1 -framerate 5 -video_size 1024x768 -i :0.0 -c:v libx264 -pix_fmt yuv420p -b:v 2500k -movflags +faststart video.mp4
