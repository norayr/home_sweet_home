fn="${1%.*}"
echo $fn
ffmpeg -i $1 -af aformat=s16:44100 ${fn}.flac
