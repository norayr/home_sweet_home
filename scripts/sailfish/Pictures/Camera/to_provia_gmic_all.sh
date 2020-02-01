set -x
for i in *.jpg
do

j="${i%.*}"
darktable-cli $i fujichrome_provia_100f.xmp ${j}_provia.jpg
gmic -input $i map_clut fuji_provia_400f -output ${j}_provia400f_gmic.jpg
gmic -input $i map_clut kodak_kodachrome_200 -output ${j}_k200_gmic.jpg
gmic -input $i map_clut kodak_elite_color_400 -output ${j}_kec400_gmic.jpg

done
