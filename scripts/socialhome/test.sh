set -x
refd=ket_favicon_370x370.png
refl=ket_favicon_370x370_light.png
list=`mktemp`

ls Social*.png > $list

while read line
do
  size=`echo $line | awk -F "-" {' print $3 '} | awk -F '.' {' print $1 '}`
  echo $size
  cp ${line} ${line}_
  light=`echo $line | grep light`
  if [[ -z "$light" ]]
  then
    convert -resize ${size}x${size} ${refd} ${line}
  else
    convert -resize ${size}x${size} ${refl} ${line}
  fi
done < $list
