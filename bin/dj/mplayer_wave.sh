#mplayer -nocache -cache-min 0 -vo gl /tmp/ffmpeg_fifo
#mplayer -nocache -cache-min 0 -vo gl udp://127.0.0.1:12345
ffplay -fflags nobuffer -flags low_delay -i udp://127.0.0.1:12345

