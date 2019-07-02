lst=`ls -d */`
for i in $lst
do
  echo $i
  if [ -z "$(ls -A $i)" ]; then
     echo "Empty"
     rmdir $i
  else
     echo "Not Empty"
  fi
done
