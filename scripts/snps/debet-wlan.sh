#connect to some wireless interface
#sudo wpa_supplicant -i wlan0 -c inky.conf
#do not run dhcpcd on it, to avoid changing systems default route
#set an ip by hand
set -x
IP0="192.168.1."
sudo ifconfig wlan0 ${IP0}23 netmask 255.255.255.0
sleep 3
#sudo route add -net 170.28.172.0/24 dev wlan0
#sudo route add -host 81.16.1.26 dev wlan0
#now setup a table for tor process by uid
#sudo ip rule add uidrange 107-108 table 502
#ip route add default via ${IP0}1 dev wlan0 table 502
    gw="${IP0}1"
    arnet="81.16.1.26"
	protonvpn="35.160.222.63"
    freenode="193.10.255.100 164.132.77.237 94.125.182.252 82.96.96.11 162.213.39.42 64.86.243.181 162.213.39.42 185.30.166.38 185.30.166.37 94.125.182.252 204.225.96.251 149.56.134.238 195.154.200.232 107.182.226.199"
    pine64="212.227.94.216"
    photonet="54.236.123.137 208.69.33.154 146.112.196.77"
    jabberorg="208.68.163.218"
    xmppjp="160.16.217.191"
    funtoo="192.150.253.217"
    github="192.30.253.112 192.30.253.113 140.82.113.3 140.82.113.4 140.82.114.3 140.82.114.4"
    hosts="$arnet $protonvpn $freenode $pine64 $photonet $jabberorg $xmppjp $funtoo $github"
    for hst in $hosts
    do
      #sudo route del -host $hst dev wlan0
      sleep 3
      sudo route add -host $hst gw $gw dev wlan0
    done
