#hints from
#https://medium.com/nerdery/dslr-webcam-setup-for-linux-9b6d1b79ae22
#https://trac.ffmpeg.org/wiki/Capture/Webcam
#https://github.com/umlaeute/v4l2loopback
#modprobe v4l2loopback exclusive_caps=1 max_buffers=2
#create v4l device
#gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video4
#now you can play it:
mplayer -tv device=/dev/video4 tv://
