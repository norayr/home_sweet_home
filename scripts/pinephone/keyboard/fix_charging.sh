cat /sys/class/power_supply/axp20x-usb/input_current_limit
#echo 1500000 > /sys/class/power_supply/axp20x-usb/input_current_limit
echo 4000000 > /sys/class/power_supply/axp20x-usb/input_current_limit
cat /sys/class/power_supply/axp20x-usb/input_current_limit

