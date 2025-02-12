mkdir ramdisk_extracted
cd ramdisk_extracted
gzip -dc ../initrd.img | cpio -idmv

