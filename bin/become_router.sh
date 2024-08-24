doas ip addr add 10.3.0.1/24 dev eth0
doas ip link set eth0 up

doas sysctl -w net.ipv4.ip_forward=1

doas iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE


##############
# run on the client board
# ip addr add 10.3.0.2/24 dev eth0
# ip link set eth0 up
# ip route add default via 10.3.0.1
#

