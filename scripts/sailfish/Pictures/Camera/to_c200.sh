set -x
i=$1

j="${i%.*}"
darktable-cli $i fujicolor_c200.xmp ${j}_c200.jpg

