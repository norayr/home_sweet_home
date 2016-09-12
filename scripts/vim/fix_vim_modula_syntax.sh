#!/bin/bash
set -x
PREFS=/usr/share/vim/vim73/filetype.vim
#A="au BufNewFile,BufRead *.m2,*.DEF,*.MOD,*.md,*.mi setf modula2"
A=".mi setf modula2"
#B="au BufNewFile,BufRead *.m2,*.DEF,*.MOD,*.md,*.mi,*.Mod setf modula2"
B=".mi,*.Mod setf modula2"
echo $A
echo $B
sed -e "s/$A/$B/g" -i $PREFS
