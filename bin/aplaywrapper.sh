lock=/tmp/aplaywrapper.tmp

if [ -f $lock ]; then
   echo "File $FILE exists."
else
  touch $lock
  vol=`amixer get Master | grep % | awk {'print $4'} | awk '{ print substr( $0, 2, 2 ) }'`
  amixer set Master 50%
  aplay $1
  amixer set Master $vol
  rm $lock
fi
