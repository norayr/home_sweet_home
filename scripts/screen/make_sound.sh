ffmpeg -f alsa -i hw:1 -ac2 -ar 44100 audio.wav


#list devices
arecord -l
arecord -L



ffmpeg -f alsa -i front:CARD=ICH5,DEV=0 -ac2 -ar 44100 audio.wav
