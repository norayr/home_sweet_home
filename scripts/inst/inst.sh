set -x
OLD=`pwd`
STAGE="https://build.funtoo.org/1.3-release-std/x86-64bit/intel64-nehalem/2019-07-10/stage3-intel64-nehalem-1.3-release-std-2019-07-10.tar.xz"
STAGE="https://build.funtoo.org/1.3-release-std/x86-64bit/core2_64/2019-07-10/stage3-core2_64-1.3-release-std-2019-07-10.tar.xz"

IMAGE="${STAGE##*/}"
CHROOT="/mnt/gentoo"
NEXT="inst2.sh"

cd $CHROOT
wget -c $STAGE
#tar xvpf $IMAGE
#mount -t proc none proc
#mount --rbind /sys sys
#mount --rbind /dev dev
#cp /etc/resolv.conf $CHROOT/etc/
#cp fstab $CHROOT/etc/
#cp portage/make.conf /etc/portage/
#cp portage/package.use /etc/portage/
cp $OLD/$NEXT $CHROOT/
env -i HOME=/root TERM=$TERM /bin/chroot . bash -l /$NEXT
