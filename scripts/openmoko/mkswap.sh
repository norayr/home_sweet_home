set -x
dd if=/dev/zero of=/media/card/swap bs=1M count=64
mkswap /media/card/swap
swapon /media/card/swap

