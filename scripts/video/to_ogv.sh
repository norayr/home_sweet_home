ffmpeg -i $1 -acodec libvorbis -vcodec libtheora -ac 2 -ab 96k -ar 44100 -b 819200 output.ogv
