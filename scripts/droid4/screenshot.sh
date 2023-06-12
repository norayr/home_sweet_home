if [ -z "$1" ]
then
  echo "no args supplied"
  DELAY="7"
else
  echo "treating $1 as delay"
fi
DATE=`date -Ins | awk -F "," {' print $1 '}`

sleep $DELAY; import -window root ${DATE}.png

#sleep 7; import -window root 202305122142.png
