set -x
package="electrum"
log="/var/log/emerge.log"
tmp=`mktemp`
tmp2=`mktemp`

tmpline_start=`grep -n "verbose $package" $log | tail -1`
tmpline_end=`grep -n "::: completed emerge" $log | grep $package | tail -1`

bnum=`echo $tmpline_start | awk -F ":" {' print $1 '}`
enum=`echo $tmpline_end | awk -F ":" {' print $1 '}`

sed -n "${bnum},${enum}p" $log > $tmp
echo $tmp

cat $tmp | grep ' Merging (' | awk -F "(" {' print $3 '} | awk -F ":" {' print $1 '}  > $tmp2
echo $tmp2

while read line
do
  emerge -C $line
done < $tmp2
