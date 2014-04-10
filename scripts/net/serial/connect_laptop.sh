#!/bin/sh

/sbin/slattach -p slip -s 115200 /dev/ttyS1 &


sleep 3s;


/sbin/ifconfig sl0 192.168.7.2 netmask 255.255.255.0 pointopoint 192.168.7.1 up

/sbin/route add -host 192.168.7.1 dev sl0

/sbin/iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

