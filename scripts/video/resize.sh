#1 - input video
#2 - resize to so many pixels
ffmpeg -i $1 -filter:v scale=$2:-1 -c:a copy test.mkv
