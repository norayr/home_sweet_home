set -x
i=$1

j="${i%.*}"
darktable-cli $i kodak_ektar_100.xmp ${j}_ektar.jpg

