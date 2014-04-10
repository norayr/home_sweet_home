#!/bin/bash
IP0="10.0.0.10"
set -x

IFACE=ppp0

while [ "1" -ne "0" ]
do

   IP=`ifconfig ppp0 | grep Mask | cut -d ":" -f 2 | cut -f 1 -d " "`

   if [ "$IP" == "$IP0" ]
   then
      date
      echo "ip ok"
   else
      echo "restarting ppp over ssh"
      ./pppssh.sh start
   fi
   sleep 15m
done

