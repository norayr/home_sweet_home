if [[ $1 == "" ]] #Where "$1" is the positional argument you want to validate

 then
 echo "no arguments, path to the picture expected"
 exit 0

fi


LUTS=`ls *.png`

CONVERT=/usr/bin/convert
FL="${1%.*}"

for LUT in $LUTS
do
  FLLUT="${LUT%.*}"
  $CONVERT $1 ${LUT} -hald-clut ${FL}-${FLLUT}.jpg
done


