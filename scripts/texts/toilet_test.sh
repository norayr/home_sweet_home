lst=`ls /usr/share/figlet`

for i in $lst
do
  echo $i
  toilet -f $i "hello! բարեւ"
done
