#!/bin/sh
if [ -z "$1" ]
then
  exit
fi

for a in $(mc-tool list | awk '/jabber/ {print $1}')
do
  mc-tool show $a
  mc-tool update $a string:resource="$1"
done
