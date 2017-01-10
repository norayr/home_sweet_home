

while true
do

layout=`setxkbmap -query | grep layout | awk {'print $2'}`

if [[ "$layout" == "us" ]]
then
  echo "fixing"
  setxkbmap "us(dvp), am, ru(phonetic)" -option "grp:alt_shift_toggle,grp_led:scroll"
fi

sleep 5


done

