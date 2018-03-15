s=$1
bn=$(basename ${s%.*})

#desaturate
saturation 0.6 $1 ${bn}_desaturated.tif

#contrast
#convert ${bn}_desaturated.tif -level 0,212,0.87 ${bn}_contrast.tif
convert ${bn}_desaturated.tif -level 0,92%,0.65 ${bn}_contrast.tif
#convert -brightness-contrast 1X20

#make highlights a bit darker
curves -s 255,255 "0,0 230,230 255,235" ${bn}_contrast.tif ${bn}_final.tif

#final image
convert -quality 95 ${bn}_final.tif ${bn}_final.jpg
