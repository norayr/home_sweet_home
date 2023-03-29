NEW=900000
BASE="/sys/devices/system/cpu/cpu0/cpufreq/base_frequency"
CUR="/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq"
SET="/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed"

echo userspace > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
#echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor


echo "     Base Freq Cur Freq New Freq"
for i in `seq 0 7`
do
  TB0=`echo $BASE | sed "s/0/${i}/"`
  TC0=`echo $CUR | sed "s/0/${i}/"`
	TS0=`echo $SET | sed "s/0/${i}/"`
	TB=`cat $TB0`; TC=`cat $TC0`
	echo 900000 > $TS0
	TS=`cat $TC0`
	echo "CPU${i}: $TB  $TC  $TS"
done

