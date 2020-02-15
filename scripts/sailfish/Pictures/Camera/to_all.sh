set -x
ext=jpg

# gets one filename to convert to all xmp styles.
toall () {
j="${1%.*}"
  for k in *.xmp
  do
    l="${k%.*}"
    darktable-cli $1 $k ${j}_${l}.${ext}
  done

}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied, applying styles to all files"
    for i in *.$ext
    do
        toall $i
    done
else
        echo "got the argument $1, applying styles to that file"
        toall $1
fi


