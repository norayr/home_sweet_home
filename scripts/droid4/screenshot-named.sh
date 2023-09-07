DST=/home/user/MyDocs/.images/screenshots
mkdir -p $DST
if [ -z "$1" ]
then
  echo "no args supplied"
  NAME=""
else
  echo "we got desired name: $1"
  NAME=$1
fi
  DELAY="7"
DATE=`date -Ins | awk -F "," {' print $1 '}`

sleep ${DELAY}; import -window root ${DST}/${DATE}_${NAME}.png

