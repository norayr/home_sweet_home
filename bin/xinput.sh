on="4 11 12 8 13"
off="13 8 12 11 4"
for i in $off
do
  xinput disable $i
  sleep 1
done

for i in $on
do
  xinput enable $i
  sleep 1
done
