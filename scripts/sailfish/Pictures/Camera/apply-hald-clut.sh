if [[ $1 == "" ]] #Where "$1" is the positional argument you want to validate 

 then
 echo "no arguments, path to the picture expected"
 exit 0

fi


LPATH="/home/nemo/lut"
LUTS="dehancer-fuji-astia-100f.png dehancer-fuji-astia-100.png dehancer-fuji-c200.png dehancer-fuji-eterna-vivid-500.png dehancer-fuji-fp100c.png dehancer-fuji-industrial-100.png dehancer-fuji-industrial-400.png dehancer-fuji-natura-1600.png dehancer-fuji-pro-400h.png dehancer-fuji-provia-100f.png dehancer-fuji-provia-400x.png dehancer-fuji-sensia-400.png dehancer-fuji-superia-1600.png dehancer-fuji-superia-200.png dehancer-fuji-velvia-100.png dehancer-fuji-velvia-50.png dehancer-ilford-hp5plus-400.png dehancer-ilford-xp2super-400.png dehancer-kodak-ektar-100.png dehancer-orwo-ut18-exp91.png dehancer-orwo-ut21-exp92.png vsco-fuji-pro-160c.png vsco-fuji-pro-160s.png vsco-fuji-pro-400h.png vsco-fuji-pro-800z.png vsco-fuji-provia-400x.png vsco-fuji-superia-100.png vsco-fuji-t64.png vsco-fuji-velvia-50.png vsco-kodachrome25.png vsco-kodak-portra-160.png vsco-kodak-portra-400.png"

#LUTS=vsco-kodachrome25.png
LUTS=vsco-fuji-velvia-50.png
LUTS=vsco-fuji-provia-400x.png

CONVERT=/usr/bin/convert
FL="${1%.*}"
FLLUT="${LUT%.*}"

for LUT in $LUTS
do
  $CONVERT $1 ${LPATH}/${LUT} -hald-clut ${FL}-${FLLUT}.jpg
done

