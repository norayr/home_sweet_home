#M="maemo-leste-1.0-amd64-virtual-20200103.qcow2"
M="maemo-leste-1.0-amd64-virtual-20200324.qcow2"

DSK="-hda $M"
KVM="-enable-kvm"
#KVM=""
SMP="-smp cores=2"
MEM="-m 1024"
NIC="-nic user,hostfwd=tcp:127.0.0.1:7722-:22"

QEMU="qemu-system-x86_64"


#qemu-system-x86_64 -hda $M -enable-kvm -cpu host -smp cores=2 -m 1024 -nic user,hostfwd=tcp:127.0.0.1:7722-:22

$QEMU $DSK $KVM $SMP $MEM $NIC
