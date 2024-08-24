doas /sbin/iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
