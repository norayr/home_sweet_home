find . | cpio --create --format='newc' | gzip > ../new_initrd.img
