set -x
ifconfig wlan0 down
rmmod iwlagn
sleep 1
modprobe iwlagn
sleep 1
iwconfig wlan0 mode ad-hoc 
sleep 1
iwconfig wlan0 essid "noch"
sleep 1
ifconfig wlan0 192.168.0.1 up
sleep 1
echo "1" > /proc/sys/net/ipv4/ip_forward

iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
#iptables --append FORWARD --in-interface wlan0 -j ACCEPT

