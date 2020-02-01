set -x
i=$1

j="${i%.*}"
darktable-cli $i fujichrome_velvia_50.xmp ${j}_velvia.jpg

