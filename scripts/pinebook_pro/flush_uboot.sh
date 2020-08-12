set -x
N=2
dd if=/usr/share/u-boot/idbloader.img of=/dev/mmcblk${N} seek=64 conv=notrunc,fsync
dd if=/usr/share/u-boot/u-boot.itb of=/dev/mmcblk${N} seek=16384 conv=notrunc,fsync
sync
