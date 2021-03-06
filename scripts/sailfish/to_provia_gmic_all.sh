set -x
for i in *.jpg
do

j="${i%.*}"
darktable-cli $i fujichrome_provia_100f.xmp ${j}_provia.jpg
gmic -input $i map_clut fuji_provia_100f -output ${j}_provia100f_gmic.jpg
gmic -input $i map_clut kodak_kodachrome_200 -output ${j}_k200_gmic.jpg
gmic -input $i map_clut kodak_kodachrome_64 -output ${j}_k64_gmic.jpg

done
