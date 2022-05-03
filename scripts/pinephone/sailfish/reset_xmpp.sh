#!/bin/sh
for a in $(mc-tool list | awk '/jabber/ {print $1}')
do
if [ $(mc-tool show "$a" | grep -c "Enabled: enabled") -eq 1 ]
then
mc-tool disable "$a"
sleep 10
mc-tool enable "$a"
sleep 10
mc-tool reconnect "$a"
mc-tool request "$a" away
fi
done
