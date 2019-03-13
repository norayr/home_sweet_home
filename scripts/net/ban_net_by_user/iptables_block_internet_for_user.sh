iptables -A OUTPUT -p tcp -mowner --uid-owner root -j DROP
iptables -A OUTPUT -p udp -mowner --uid-owner root -j DROP
iptables -A OUTPUT -p icmp -mowner --uid-owner root -j DROP
