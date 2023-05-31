FL="${1%.*}"

sh imagemagick/filmgrain -a 100 -A 0 -c hardlight $1 ${FL}_n.jpg
#for bw
#sh imagemagick/filmgrain -a 100 -A 0 -c hardlight -m $1 ${FL}_n.jpg
