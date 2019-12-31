#connect to some wireless interface
#do not run dhcpcd on it, to avoid changing systems default route
#set an ip by hand
#sudo ifconfig wlan0 172.28.172.23 netmask 255.255.255.0
#sudo route add -net 170.28.172.0/24 dev wlan0
#now setup a table for tor process by uid
#sudo ip rule add uidrange 107-108 table 502
#ip route add default via 172.28.172.1 dev wlan0 table 502
