TARGET=/home/arax-pi
mount -o bind /proc $TARGET/proc
mount -o bind /dev $TARGET/dev
chroot $TARGET
#chroot $TARGET /opt/qemu-pi/bin/qemu-arm
