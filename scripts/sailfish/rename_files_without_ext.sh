set -x
cd ~/Pictures/DailyComics

list=`ls | grep -v "\."`

for i in $list
do
   tp=`file $i | awk {' print $2 '}`
   if [ "$tp" = "JPEG" ]
   then
     mv $i $i.jpg
   fi
   if [ "$tp" = "GIF" ]
   then
     mv $i $i.gif
   fi
   if [ "$tp" = "PNG" ]
   then
     mv $i $i.png
   fi

done
