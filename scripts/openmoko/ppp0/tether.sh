#!/bin/sh
IPTABLES='/usr/sbin/iptables'

# Set interface values
EXTIF='ppp0'
INTIF='usb0'

# enable ip forwarding in the kernel
/bin/echo 1 > /proc/sys/net/ipv4/ip_forward

# flush rules and delete chains
$IPTABLES -F
#$IPTABLES -X

$IPTABLES --flush
$IPTABLES --table nat --flush
$IPTABLES --delete-chain
$IPTABLES --table nat --delete-chain

#Enable masquerading to allow LAN internet access
$IPTABLES -t nat -A POSTROUTING -o $EXTIF -j MASQUERADE
