#SAVEIFS=$IFS
#IFS=$(echo -en "\n\b")
#for i in *.flac
#do
#nm=${i%.*}
#echo $nm
#ffmpeg -i "$i" -ab 320k -map_metadata 0 -id3v2_version 3 ${nm}.mp3
ffmpeg -f concat -safe 0 -i mylist.txt -ab 320k -map_metadata 0 -id3v2_version 3 out.mp3
#done
#IFS=$SAVEIFS
