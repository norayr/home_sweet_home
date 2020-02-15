set -x
i=$1

j="${i%.*}"
darktable-cli $i fujichrome_astia_100f_daylight.xmp ${j}_astia.jpg

