s=$1
bn=$(basename ${s%.*})
saturation 0.6 $1 ${bn}_desaturated.tif
#convert ${bn}_desaturated.tif -level 0,212,0.87 ${bn}_final.tif
convert ${bn}_desaturated.tif -level 0,92%,0.65 ${bn}_contrast.tif
curves -s 255,255 "0,0 230,230 255,235" ${bn}_contrast.tif ${bn}_final.tif
convert -quality 95 ${bn}_final.tif ${bn}_final.jpg
