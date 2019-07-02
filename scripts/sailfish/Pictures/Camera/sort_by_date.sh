set -x
self=`basename "$0"`
list=`ls *.jpg | grep -v $self`
tmpf=`mktemp`

for i in $list
do

 st=`stat $i | grep Modify | awk {' print $2 '} | cut -d'-' -f2-`
# echo $st
 echo $st >> $tmpf

done

dirs=`cat $tmpf | sort | uniq`

for i in $dirs
do
  echo $i
  mkdir -p $i
done

for i in $list
do

 st=`stat $i | grep Modify | awk {' print $2 '} | cut -d'-' -f2-`
 mv $i $st/
done


