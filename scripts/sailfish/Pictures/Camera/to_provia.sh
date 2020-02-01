set -x
i=$1

j="${i%.*}"
darktable-cli $i fujichrome_provia_100f.xmp ${j}_provia.jpg

