#!/bin/bash
set -x
af=`ls | grep -v ".sh"`

#echo $af > tmp_list.txt

#csplit -k tmp_list.txt  20  {20}
let j=0
let k=0
for i in $af
do
      if (( j < 10 ))
      then
         n=0$j
      else
         n=$j
      fi
   if [ ! -d $n ]
   then
      mkdir $n
   fi
   mv $i $n
   let k++
   echo "k=$k"
   if (( k == 20 ))
   then
      let j++
      let k=0
   fi
   
done



