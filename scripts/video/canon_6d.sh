#hints from
#https://medium.com/nerdery/dslr-webcam-setup-for-linux-9b6d1b79ae22
#https://trac.ffmpeg.org/wiki/Capture/Webcam
#https://github.com/umlaeute/v4l2loopback
#modprobe v4l2loopback exclusive_caps=1 max_buffers=2
#create v4l device
#sizes
# ALL-I or IPB
#1920x 1080p (30/25/24 fps)
#1280 x 720p (60/50fps)
# IPB
#640 x 480 (30 fps)
#gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -s 1280x720 -threads 2 -f v4l2 /dev/video4
#now you can play it:
#mplayer -tv device=/dev/video4 tv://
#stream with
#https://stackoverflow.com/questions/47375345/youtube-live-not-working-with-ffmpeg
#ffmpeg -f alsa -ac 2 -i hw:0,0 -f v4l2 -s 1280x720 -r 30 -i /dev/video4 -vcodec libx264 -pix_fmt yuv420p -preset ultrafast -strict experimental -r 30 -g 20 -b:v 2500k -codec:a libmp3lame -ar 44100 -b:a 11025 -bufsize 512k -f flv rtmp://a.rtmp.youtube.com/live2/3yqq-9dvb-22h6-2xdk
#https://gist.github.com/laurenarcher/4644aacef51e734d33d5
#ffmpeg -f alsa -ac 2 -i hw:1,0 -f v4l2 -s 1280x720 -r 10 -i /dev/video1 -vcodec libx264 -pix_fmt yuv420p -preset ultrafast -r 25 -g 20 -b:v 2500k -codec:a libmp3lame -ar 44100 -threads 6 -b:a 11025 -bufsize 512k -f flv rtmp://a.rtmp.youtube.com/live2/YOURSTREAMNAMEHERE
#see also
#http://trac.ffmpeg.org/wiki/EncodingForStreamingSites
