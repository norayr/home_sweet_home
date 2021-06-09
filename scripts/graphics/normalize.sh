list=`ls *.bmp`

for i in $list
do
  NUMBER=$(echo $i | grep -o -E '[0-9]+')
  NEWNUM=`printf "%03d\n" "${NUMBER#0}"`
  j=`echo $i | sed "s/$NUMBER/$NEWNUM/"`
  echo "$i becomes $j"
  mv $i $j
done
