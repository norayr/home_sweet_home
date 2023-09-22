#set -x
if [ "$1" == "ru" ]
then
#setxkbmap "us(dvp), am, ru(phonetic)" -option "grp:lalt_shift_toggle"
#setxkbmap "us(dvp), am, ru" -option "grp:lalt_shift_toggle"
setxkbmap "us(dvp), am, ru(phonetic_dvorak)" -option "grp:lalt_shift_toggle"
elif [ "$1" == "eo" ]
then
	setxkbmap "us(dvp), am, epo(dvorak)" -option "grp:lalt_shift_toggle,lv3:ralt_switch" 
elif [ "$1" == "ge" ]
then
  setxkbmap "us(dvp), am, ge" -option "grp:lalt_shift_toggle"
else
  setxkbmap "us(dvp), am" -option "grp:lalt_shift_toggle"
fi
