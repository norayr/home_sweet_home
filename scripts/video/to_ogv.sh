#ffmpeg -i $1 -acodec libvorbis -vcodec libtheora -ac 2 -ab 96k -ar 44100 -b 819200 output.ogv
ffmpeg -i $1 -c:v libtheora -q:v 7 -c:a libvorbis -q:a 4 output.ogv
