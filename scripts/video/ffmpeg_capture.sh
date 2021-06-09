# https://wiki.batc.org.uk/Fushicai_USBTV007

#sudo v4l2-ctl -d /dev/video4 --set-standard=6 #PAL

#sudo v4l2-ctl -d /dev/video4 --set-input=0 #composite input

PAL_RES="720x576"
NTSC_RES="720x480"

#ffmpeg -f alsa -channels 1 -sample_rate 44100 -i default:CARD=Rmx2 out.wav
#ffmpeg -f v4l2 -video_size 720x480 -i /dev/video0 -channel_layout stereo -f alsa -channels 1 -sample_rate 44100 -thread_queue_size 4096 -i default:CARD=Rmx2  -c:v libx264 -pix_fmt yuv420p -b:v 2M -crf 23  -preset fast out2.mkv
#v4l2-ctl --list-formats-ext

ffmpeg \
	-f v4l2 -framerate 25 -video_size 720x480 -i /dev/video4 \
	-f alsa -ac 2 -sample_rate 44100 -thread_queue_size 4096 -i default:CARD=Rmx2 \
	-c:v libx264 -g 25 -pix_fmt yuv420p -b:v 2M   -preset fast \
	-c:a aac -b:a 128k \
	out2.mkv
