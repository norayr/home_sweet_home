#find . -type f -name '*.mp4' -exec bash -c 'avconv -i "$0" -c:a copy "${0/%mp4/m4a}"' {} \;
find . -type f -name '*.mp4' -exec bash -c 'ffmpeg -i "$0" -acodec copy "${0/%mp4/m4a}"' {} \;

