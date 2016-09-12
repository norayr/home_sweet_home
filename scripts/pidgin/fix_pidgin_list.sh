#!/bin/bash
set -x
PREFS=/home/noch/.purple/prefs.xml
A="<pref name='list_visible' type='bool' value='0'"
B="<pref name='list_visible' type='bool' value='1'"
echo $A
echo $B

sed -e "s/$A/$B/g" -i $PREFS
