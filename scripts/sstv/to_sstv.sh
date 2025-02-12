. ~/pip/sstv/bin/activate
sleep 5

for i in *.jpg; do echo $i; j="${i%.*}"; echo $j; convert $i ${j}.png; done

sleep 5

for i in *.png; do echo $i; j="${i%.*}"; echo $j; pysstv --resize --keep-aspect-ratio --mode Robot36 $i ${j}_r36.wav; pysstv --resize --keep-aspect-ratio --mode PD240 $i ${j}_pd240.wav; done

for i in *.wav; do j=${i%.*};  ffmpeg -i $i -ab 320k -map_metadata 0 -id3v2_version 3 ${j}.mp3; done
