#!/bin/sh

slattach -p slip -s 115200 /dev/ttyS0

ifconfig sl0 192.168.0.1 netmask 255.255.255.0 pointopoint 192.168.0.2 up

route add -host 192.168.0.2 dev sl0

