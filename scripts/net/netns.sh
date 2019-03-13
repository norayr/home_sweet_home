#create netns
ip netns add myNamespace
#link iface to netns
ip link set wlan0 netns myNamespace
#set ip address in namespace
ip netns exec myNamespace ifconfig wlan0  172.28.172.0/24 up
#set loopback (may be needed by process run in this namespace)
ip netns exec myNamespace ifconfig lo 127.0.0.1/8 up
#set route in namespace
ip netns exec myNamespace route add default gw 172.28.172.1
#force firefox to run inside namespace (using eth0 as outgoing interface and the route)
ip netns exec myNamespace tor
#ip netns exec myNamespace /usr/bin/tor
