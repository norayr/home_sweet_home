DT=`date "+%Y.%m.%d-%H:%M:%S"`

echo $DT

ssh root@192.168.1.1 "date ${DT}"
ssh root@192.168.1.1 "sh /etc/rc.local"

