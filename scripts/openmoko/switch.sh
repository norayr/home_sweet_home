
if [ -f /usr/share/X11/xkb/symbols/am ]
then
cp am /usr/share/X11/xkb/symbols/
fi

setxkbmap "us(intl), am(phonetic)" -option "grp:ctrl_shift_toggle"
