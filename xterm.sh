export TERM=xterm-256color ; reset

tput colors
#256

###!/bin/bash

for ((i=0; i<256; i++)) ;do
    echo -n '  '
    tput setab $i
    tput setaf $(( ( (i>231&&i<244 ) || ( (i<17)&& (i%8<2)) ||
        (i>16&&i<232)&& ((i-16)%6 <(i<100?3:2) ) && ((i-16)%36<15) )?7:16))
    printf " C %03d " $i
    tput op
    (( ((i<16||i>231) && ((i+1)%8==0)) || ((i>16&&i<232)&& ((i-15)%6==0)) )) &&
        printf "\n" ''
done

#color names
#https://invisible-island.net/xterm/xterm.faq.html#color_by_number

#how to change palette
#https://stackoverflow.com/questions/27159322/rgb-values-of-the-colors-in-the-ansi-extended-colors-index-17-255

#black
echo -en "\e]4;0;#2e3440\e\\"
#echo -en "\e]4;0;#4c566a\e\\"
#red
echo -en "\e]4;1;#b26a7d\e\\"
#green
echo -en "\e]4;2;#97ba97\e\\"
#yellow
echo -en "\e]4;3;#c2c270\e\\"
#blue
echo -en "\e]4;4;#81a1c1\e\\"
#magenta
echo -en "\e]4;5;#b48ead\e\\"
#cyan
echo -en "\e]4;6;#87c0d0\e\\"
#white
echo -en "\e]4;7;#dbe0ea\e\\"
#color8 gray30
#color9 red
echo -en "\e]4;9;#b26a7d\e\\"
#color10 green
echo -en "\e]4;10;#97ba97\e\\"
#color11 yellow
echo -en "\e]4;11;#c2c270\e\\"
#color12 blue
echo -en "\e]4;12;#81a1c1\e\\"
#color13 magenta
echo -en "\e]4;13;#b48ead\e\\"
#color14 cyan
echo -en "\e]4;14;#87c0d0\e\\"
#color15 white
echo -en "\e]4;15;#dbe0ea\e\\"
