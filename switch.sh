if [ "$1" == "ru" ]
then
setxkbmap "us(dvp), am, ru(phonetic)" -option "grp:alt_shift_toggle"
else
setxkbmap "us(dvp), am" -option "grp:alt_shift_toggle"
fi
