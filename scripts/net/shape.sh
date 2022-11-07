#! /bin/bash
#NETCARD=eth0
NETCARD=eno1
MAXBANDWIDTH=100000
set -x
# reinit
tc qdisc del dev $NETCARD root handle 1
tc qdisc add dev $NETCARD root handle 1: htb default 9999

# create the default class
tc class add dev $NETCARD parent 1:0 classid 1:9999 htb rate $(( $MAXBANDWIDTH ))kbit ceil $(( $MAXBANDWIDTH ))kbit burst 5k prio 9999

# control bandwidth per IP
declare -A ipctrl
# define list of IP and bandwidth (in kilo bits per seconds) below
#ipctrl[192.168.1.1]="256"
#ipctrl[192.168.1.2]="128"
#ipctrl[192.168.1.3]="512"
#ipctrl[192.168.1.4]="32"

mark=0
for ip in "${!ipctrl[@]}"
do
    mark=$(( mark + 1 ))
    bandwidth=${ipctrl[$ip]}

    # traffic shaping rule
    tc class add dev $NETCARD parent 1:0 classid 1:$mark htb rate $(( $bandwidth ))kbit ceil $(( $bandwidth ))kbit burst 5k prio $mark

    # netfilter packet marking rule
    iptables -t mangle -A INPUT -i $NETCARD -s $ip -j CONNMARK --set-mark $mark

    # filter that bind the two
    tc filter add dev $NETCARD parent 1:0 protocol ip prio $mark handle $mark fw flowid 1:$mark

    echo "IP $ip is attached to mark $mark and limited to $bandwidth kbps"
done

#propagate netfilter marks on connections
iptables -t mangle -A POSTROUTING -j CONNMARK --restore-mark
