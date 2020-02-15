set -x
ext=jpg

for i in *.$ext
do

j="${i%.*}"
  for k in *.xmp
  do
    l="${k%.*}"
    darktable-cli $i $k ${j}_${l}.${ext}
  done
done

