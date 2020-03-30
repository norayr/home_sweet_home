#ffmpeg -re -i content.mp4 -map 0:0 -map 0:2 -c:v libx264 -vprofile baseline -preset ultrafast -tune zerolatency -r 25 -pix_fmt yuv420p -c:a libfdk_aac -ac 2 -ar 44100 -f flv rtmp://192.168.1.2/live
#ffmpeg -re -i content.mp4 -map 0:0 -map 0:2 -c:v libx264 -vprofile baseline -preset ultrafast -tune zerolatency -r 25 -pix_fmt yuv420p -c:a aac -ac 2 -ar 44100 -f flv rtmp://192.168.1.2/live
#jibri
#ffmpeg -y -v info -f x11grab -draw_mouse 0 -r 30 -s 1280x720 -thread_queue_size 4096 -i :0.0+0,0 -f alsa -thread_queue_size 4096 -i plug:bsnoop -acodec aac -strict -2 -ar 44100 -c:v libx264 -preset veryfast -maxrate 2976k -bufsize 5952k -pix_fmt yuv420p -r 30 -crf 25 -g 60 -tune zerolatency -f flv rtmp://a.rtmp.youtube.com/live2/STREAM_KEY_HERE
#ffmpeg -i any_file.mp4 -strict experimental -acodec aac -ac 1 -ar 44100 -vcodec libx264 -pix_fmt yuv420p -g 30 -vb 512k -profile:v main -preset ultrafast -r 30 -f flv -s 854x480 rtmp://a.rtmp.youtube.com/live2/your-channel.stream_code
ffmpeg -i content.mp4 -strict experimental -acodec aac -ac 1 -ar 44100 -vcodec libx264 -pix_fmt yuv420p -g 30 -vb 512k -profile:v main -preset ultrafast -r 30 -f flv -s 854x480 rtmp://192.168.1.2/live
