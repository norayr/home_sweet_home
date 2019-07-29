set -x
sudo /sbin/ifconfig wlan0 down
sleep 3
sudo iwconfig wlan0
sudo /sbin/ifconfig wlan0 up
while true
do
  test=`/sbin/iwconfig wlan0 | grep synopsys`

  if [ -z "$test" ]
  then
    sudo /sbin/ifconfig wlan0 up
    sudo /sbin/iwlist wlan0 scan | grep SSID
    sudo /sbin/iwconfig wlan0 essid "synopsys-guest"
    sudo dhcpcd wlan0
    connected=""
	while [ -z "$connected" ]
	do
	   connected=`/sbin/ifconfig wlan0 | grep -w inet`
	   sleep 5
	done
	
	fusermount -uz /amp
	gw=`route -n | grep UG | grep wlan0 | awk {' print $2 '}`
	gw=`echo $gw | awk {' print $1 '}`
    sudo route del -net 0.0.0.0 dev wlan0
    #sudo route add -host 212.34.243.186 gw $gw dev wlan0
    sudo route add -host 81.16.1.26  gw $gw dev wlan0

    #irc.freenode.net
    sudo route add -host 162.213.39.42   gw $gw dev wlan0
    sudo route add -host 185.30.166.38   gw $gw dev wlan0
    sudo route add -host 185.30.166.37   gw $gw dev wlan0
    sudo route add -host 94.125.182.252  gw $gw dev wlan0
    sudo route add -host 204.225.96.251  gw $gw dev wlan0
    sudo route add -host 149.56.134.238  gw $gw dev wlan0
    sudo route add -host 195.154.200.232 gw $gw dev wlan0

    #photo.net
    sudo route add -host 54.236.123.137 gw $gw dev wlan0

    #jabber.org
    sudo route add -host 208.68.163.218 gw $gw dev wlan0

    #xmpp.jp
    sudo route add -host 160.16.217.191 gw $gw dev wlan0
    #
    #sudo route add -host 212.34.243.186 gw $gw dev wlan0
    #sudo route add -host 212.34.243.186 gw $gw dev wlan0

	fusermount -uz /amp
	sshfs root@arnet.am:/amp /amp
	bash uploads.sh
  fi
sleep 60
done
