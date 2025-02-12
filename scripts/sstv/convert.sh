set -x
. ~/pip/sstv/bin/activate

MODE="PD240"
MODE="Robot36"

SSTV="pysstv --resize --keep-aspect-ratio --mode ${MODE}"

for i in *.png
do
  j=${i%.*}
	nf=${j}_${MODE}
  $SSTV $i ${nf}.wav
  ffmpeg -i "${nf}.wav" -ab 320k -map_metadata 0 -id3v2_version 3 ${nf}.mp3
	rm -f ${nf}.wav
done
