files="photo2012.11.08_16.46.58.36.dng_357GNW.png
photo2012.11.08_16.46.58.36.dng_357GNW_sm.png
photo2012.11.08_16.46.58.36.dng_S34ENW.png
photo2012.11.08_16.46.58.36.dng_S34ENW_sm.png
photo2012.11.08_16.47.05.26.dng_TSX1MW.png
photo2012.11.08_16.47.05.26.dng_TSX1MW_sm.png
photo2012.11.08_16.47.05.26.png
photo2012.11.08_16.47.05.26_sm.png
"

for f in $files
do


exiftool -P -GPSLatitude=40.1801377 -GPSLongitude=44.5115751 -GPSImgDirection=230.3 $f 

done
