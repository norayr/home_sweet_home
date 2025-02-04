#modprobe v4l2loopback exclusive_caps=1 max_buffers=2
#sleep 5
gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -s 1368x912 -threads 2 -f v4l2 /dev/video0
#gphoto2 --stdout --capture-movie | ffmpeg -i - -vcodec rawvideo -pix_fmt yuv420p -s 1024x683 -threads 2 -f v4l2 /dev/video0
