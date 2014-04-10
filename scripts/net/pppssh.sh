#!/bin/sh
# /usr/local/bin/vpn-pppssh
#
# This script initiates a ppp-ssh vpn connection.
# see the VPN PPP-SSH HOWTO on http://www.linuxdoc.org for more information.
#
# revision history:
# 1.6 11-Nov-1996 miquels@cistron.nl
# 1.7 20-Dec-1999 bart@jukie.net
# 2.0 16-May-2001 bronson@trestle.com


#
# You will need to change these variables...
#


# The host name or IP address of the SSH server that we are
# sending the connection request to:
SERVER_HOSTNAME=<hostname>

# The username on the VPN server that will run the tunnel.
# For security reasons, this should NOT be root.  (Any user
# that can use PPP can intitiate the connection on the client)
SERVER_USERNAME=root

# The VPN network interface on the server should use this address:
SERVER_IFIPADDR=10.0.0.1

# ...and on the client, this address:
CLIENT_IFIPADDR=10.0.0.10


# This tells ssh to use unprivileged high ports, even though it's
# running as root.  This way, you don't have to punch custom holes
# through your firewall.
#LOCAL_SSH_OPTS="-P"
LOCAL_SSH_OPTS="-p 21"


#
# The rest of this file should not need to be changed.
#



PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/bin/X11/:

#
# required commands...
#

PPPD=/usr/sbin/pppd
SSH=/usr/bin/ssh

if ! test -f $PPPD  ; then echo "can't find $PPPD";  exit 3; fi
if ! test -f $SSH   ; then echo "can't find $SSH";   exit 4; fi


case "$1" in
  start)
    # echo -n "Starting vpn to $SERVER_HOSTNAME: "
    ${PPPD} updetach noauth passive pty "${SSH} ${LOCAL_SSH_OPTS} ${SERVER_HOSTNAME} -l${SERVER_USERNAME} -o Batchmode=yes sudo ${PPPD} nodetach notty noauth" ipparam vpn ${CLIENT_IFIPADDR}:${SERVER_IFIPADDR}
    # echo "connected."
    ;;

  stop)
        # echo -n "Stopping vpn to $SERVER_HOSTNAME: "
        PID=`ps ax | grep "${SSH} ${LOCAL_SSH_OPTS} ${SERVER_HOSTNAME} -l${SERVER_USERNAME} -o" | grep -v ' passive ' | grep -v 'grep ' | awk '{print $1}'`
        if [ "${PID}" != "" ]; then
          kill $PID
          echo "disconnected."
        else
          echo "Failed to find PID for the connection"
        fi
    ;;

  config)
    echo "SERVER_HOSTNAME=$SERVER_HOSTNAME"
    echo "SERVER_USERNAME=$SERVER_USERNAME"
    echo "SERVER_IFIPADDR=$SERVER_IFIPADDR"
    echo "CLIENT_IFIPADDR=$CLIENT_IFIPADDR"
  ;;

  *)
    echo "Usage: vpn {start|stop|config}"
    exit 1
    ;;
esac

exit 0
