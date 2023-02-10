vn=`cat /sys/class/power_supply/axp20x-battery/voltage_now`
cn=`cat /sys/class/power_supply/axp20x-battery/current_now`
m=`echo -${vn}*${cn} | bc`
echo $m
echo "scale=4; 1100000000000/${m}" | bc
