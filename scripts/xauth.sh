a=`xauth list | awk {' print $3 '}`
key=`echo $a | awk '{print $NF}'`
xauth add "$(hostname)/unix:0" MIT-MAGIC-COOKIE-1 $key

