#install sys-apps/pcsc-lite
#/etc/init.d/pcsc-lite start
sudo sh -c 'curl https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules > /etc/udev/rules.d/70-u2f.rules'
