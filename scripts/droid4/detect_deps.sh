PRG="/usr/bin/osso-xterm.launch"
TMPFILE=`mktemp`
OUT=`mktemp`

ldd $PRG > $TMPFILE

while read line
do

  if [[ $line == *"=>"* ]]; then
    BIN=`echo $line | awk {' print $3 '}`
    echo $BIN
    PKG=`dpkg -S $BIN | awk -F ":" {' print $1 '}`
    echo $PKG
    echo $PKG >> $OUT

  fi


done < $TMPFILE
