#on am04admin
#mount zoo2:/vol/vol0  /mnt/zoo2
#mount zoo2:/vol/DATA2/data2 /mnt/zoo2_data2
#mount zoo1:/vol/DATA1/data1 /mnt/zoo1_data1


#on localhost
#emerge nfs-utils
#/etc/init.d/nfs start
#rc-update add nfs default
vim /mnt/zoo2/etc/exports
vim /mnt/zoo2/etc/hosts
/usr/bin/rsh zoo2 "exportfs -r"

mount zoo2:/vol/DATA2/data2/users/noch/ /amp_snps
cd /amp_snps
encfs /amp_snps/encrypted /amp_snps/decrypted
