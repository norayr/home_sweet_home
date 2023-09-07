DST=/home/user/MyDocs/.images/screenshots
#mkdir -p $DST
#if [ -z "$1" ]
#then
#  echo "no args supplied"
#  DELAY="7"
#else
#  echo "treating $1 as delay"
#  DELAY=$1
#fi
#DATE=`date -Ins | awk -F "," {' print $1 '}`
#
#sleep ${DELAY}; 
import -window root ${DST}/${DATE}.png

