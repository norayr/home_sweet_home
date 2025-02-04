set -x
rm /tmp/ffmpeg_fifo
sleep 1
mkfifo /tmp/ffmpeg_fifo
sleep 1
#ffmpeg -f jack -i ffmpeg -filter_complex "[0:a]showwaves=s=1920x300:mode=line:rate=25,format=yuv420p[v]" -map "[v]" -f mpegts /tmp/ffmpeg_fifo
ffmpeg -f jack -i ffmpeg -filter_complex "[0:a]showwaves=s=1920x300:mode=line:rate=25,format=yuv420p[v]" -map "[v]" -f mpegts udp://127.0.0.1:12345

