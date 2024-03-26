#!/bin/sh

iface="$(ip -4 r | grep '^default via' | sed 1q | cut -d' ' -f5)"

if [ -z "$iface" ]; then
  echo "Error: No network interface found." >&2
  exit 1
fi

enable_tproxy() {
  cp -f /etc/resolv.conf /etc/resolv.conf.orig
  echo "nameserver 127.0.0.1" > /etc/resolv.conf

  _tor_uid="$(id -u tor)"
  _trans_port="9040"
  _dns_port="5353"
  _virt_addr="10.192.0.0/10"
  _out_if="$iface"

  # LAN destinations that shouldn't be routed through Tor
  _non_tor="127.0.0.0/8 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 192.168.1.0/16"

  # Other IANA reserved blocks (These are not processed by tor and dropped by default)
  _resv_iana="0.0.0.0/8 100.64.0.0/10 169.254.0.0/16 192.0.0.0/24 192.0.2.0/24 192.88.99.0/24 198.18.0.0/15 198.51.100.0/24 203.0.113.0/24 224.0.0.0/4 240.0.0.0/4 255.255.255.255/32"

  ### Don't lock yourself out after the flush
  #iptables -P INPUT ACCEPT
  #iptables -P OUTPUT ACCEPT

  iptables -F
  iptables -t nat -F

  ### *nat OUTPUT (For local redirection)
  # nat .onion addresses
  iptables -t nat -A OUTPUT -d $_virt_addr \
    -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN \
    -j REDIRECT --to-ports $_trans_port

  # nat dns requests to Tor
  iptables -t nat -A OUTPUT -d 127.0.0.1/32 \
    -p udp -m udp --dport 53 -j REDIRECT --to-ports $_dns_port

  # Don't nat the Tor process, the loopback, or the local network
  iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN
  iptables -t nat -A OUTPUT -o lo -j RETURN

  # Allow lan access for hosts in $_non_tor
  for _lan in $_non_tor; do
    iptables -t nat -A OUTPUT -d $_lan -j RETURN
  done

  for _iana in $_resv_iana; do
    iptables -t nat -A OUTPUT -d $_iana -j RETURN
  done

  # Redirect all other pre-routing and output to Tor's TransPort
  iptables -t nat -A OUTPUT -p tcp -m tcp \
    --tcp-flags FIN,SYN,RST,ACK SYN -j REDIRECT --to-ports $_trans_port

  ### *filter INPUT
  # Don't forget to grant yourself ssh access from remote machines before the DROP.
  #iptables -A INPUT -i $_out_if -p tcp --dport 22 -m state --state NEW -j ACCEPT

  iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
  iptables -A INPUT -i lo -j ACCEPT

  # Allow INPUT from lan hosts in $_non_tor
  # Uncomment these 3 lines to enable.
  #for _lan in $_non_tor; do
  # iptables -A INPUT -s $_lan -j ACCEPT
  #done

  # Log & Drop everything else. Uncomment to enable logging
  #iptables -A INPUT -j LOG --log-prefix "Dropped INPUT packet: " --log-level 7 --log-uid
  iptables -A INPUT -j DROP

  ### *filter FORWARD
  iptables -A FORWARD -j DROP

  ### *filter OUTPUT
  iptables -A OUTPUT -m state --state INVALID -j DROP
  iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT

  # Allow Tor process output
  iptables -A OUTPUT -o $_out_if -m owner --uid-owner $_tor_uid \
    -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j ACCEPT

  # Allow loopback output
  iptables -A OUTPUT -d 127.0.0.1/32 -o lo -j ACCEPT

  # Tor transproxy magic
  iptables -A OUTPUT -d 127.0.0.1/32 -p tcp -m tcp --dport $_trans_port \
    --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT

iptables -t nat -A OUTPUT -d 127.0.0.1/32 -p udp -m udp --dport 53 -j REDIRECT --to-ports $_dns_port


  # Allow OUTPUT to lan hosts in $_non_tor
  # Uncomment these 3 lines to enable.
  #for _lan in $_non_tor; do
  # iptables -A OUTPUT -d $_lan -j ACCEPT
  #done

  # Log & Drop everything else. Uncomment to enable logging
  #iptables -A OUTPUT -j LOG --log-prefix "Dropped OUTPUT packet: " --log-level 7 --log-uid
  iptables -A OUTPUT -j DROP

  ### Set default policies to DROP
  iptables -P INPUT DROP
  iptables -P FORWARD DROP
  iptables -P OUTPUT DROP

  ### Set default policies to DROP for IPv6
  ip6tables -P INPUT DROP
  ip6tables -P FORWARD DROP
  ip6tables -P OUTPUT DROP
}

disable_tproxy() {
  cp -f /etc/resolv.conf.orig /etc/resolv.conf

  iptables -F
  iptables -t nat -F
  iptables -P INPUT ACCEPT
  iptables -P FORWARD ACCEPT
  iptables -P OUTPUT ACCEPT
  ip6tables -P INPUT ACCEPT
  ip6tables -P FORWARD ACCEPT
  ip6tables -P OUTPUT ACCEPT
}

case "$1" in
enable)
  enable_tproxy
  ;;
disable)
  disable_tproxy
  ;;
esac
