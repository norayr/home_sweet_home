fn="${1%.*}"
echo $fn
ffmpeg -i $1 -af aformat=s16:44100 ${fn}.flac
#ffmpeg -f concat -safe 0 -i mylist.txt -af aformat=s16:44100 2020-08-29_vanadzor_solenoid.flac
