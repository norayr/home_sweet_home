i=$1
name=${i%.*}
ffmpeg -i $1 -s 176x144 -acodec libfaac -ac 1 -ar 32000 -ab 32 $name.3gp

#-s qcif
# -acodec mp3 -ac 1 -ab 32 -y $2
#-ar 8000
