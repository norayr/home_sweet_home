#tar -cf - env/novation | ssh arnet.am "cd /tmp; tar -xf -"
set -x
tar -cf - $1 | ssh $2 "cd $3; tar -xf -"
