export DISPLAY=":0"
appenddate=_$(date '+%d%b%y-%H%M%S')
fname=screenshot$appenddate.png
gst-launch-0.10 ximagesrc num-buffers=1 ! ffmpegcolorspace ! pngenc ! filesink location=$fname
