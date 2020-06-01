VBR="2500k"                                    # Bitrate de la vidéo en sortie
FPS="30"                                       # FPS de la vidéo en sortie
QUAL="medium"                                  # Preset de qualité FFMPEG
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2"  # URL de base RTMP youtube

#SOURCE=" -i udp://239.255.139.0:1234"              # Source UDP (voir les annonces SAP)
SOURCE=" -f v4l2 -i /dev/video4 "
KEY="3yqq-9dvb-22h6-2xdk"                                     # Clé à récupérer sur l'event youtube

ffmpeg \
     "$SOURCE"  \
    -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -r $FPS -g $(($FPS * 2)) -b:v $VBR \
    -acodec libmp3lame -ar 44100 -threads 6 -qscale 3 -b:a 712000 -bufsize 512k \
    -f flv "$YOUTUBE_URL/$KEY"
