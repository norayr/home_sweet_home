if [ -n "$1" ]
then
  echo "got $1"
  LAST=$1
else
  echo "no args"
	LAST="/tmp"
fi

LFILE=`ls -t $LAST | head -1`

xv $LAST/$LFILE

