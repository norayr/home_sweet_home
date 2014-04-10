#!/bin/bash

set -x
IFACE=wlan0
ESSID=welcome_to_norayrs_piratebox
MYTEMPHOSTNAME=maemo
ADDR=23.23.23.23
NETMASK=255.255.255.0
ADDR_MIN=23.23.23.0
ADDR_MAX=23.23.23.255
INT=1

ifconfig $IFACE down
sleep $INT 
ifconfig $IFACE up
sleep $INT
iwconfig $IFACE mode ad-hoc
sleep $INT
iwconfig $IFACE essid $ESSID
sleep $INT
ifconfig $IFACE $ADDR netmask $NETMASK up

/usr/sbin/dnsmasq -i $IFACE -a $ADDR -I lo -z -d \
                  -x /var/run/dnsmasq.$IFACE.pid \
                  --dhcp-range=$ADDR_MIN,$ADDR_MAX,6h \
		  --address=/#/$ADDR \
		  --no-resolv
#		  --domain-needed \
#		  --bogus-priv \
#		  --bogus-nxdomain=$ADDR

