#tar -cf - env/novation | ssh am04admin "cd /tmp; tar -xf -"
set -x
tar -cf - $1 | ssh am04admin "cd $2; tar -xf -"
