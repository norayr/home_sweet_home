PERCENT=$(cat /sys/class/power_supply/cw2015-battery/capacity)
STATUS=$(cat /sys/class/power_supply/cw2015-battery/status)

echo $PERCENT
echo $STATUS

TEMP0=$(cat /sys/devices/virtual/thermal/thermal_zone0/temp)
TEMP1=$(cat /sys/devices/virtual/thermal/thermal_zone1/temp)
TEMP2=$(cat /sys/devices/virtual/thermal/thermal_zone2/temp)

echo "temps: $TEMP0 $TEMP1 $TEMP2"
