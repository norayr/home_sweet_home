  sudo acpitool -s
  ST=`cat /proc/acpi/button/lid/LID0/state | awk {' print $2 '}`
  while [ "$ST" == "closed" ]; do
  ST=`cat /proc/acpi/button/lid/LID0/state | awk {' print $2 '}`
    echo "closed"
    sudo acpitool -s
	  sleep 5;
  done

#sudo acpitool -s
#sudo acpitool -s
#sudo acpitool -s
#sudo acpitool -s
#sudo acpitool -s
#sudo acpitool -s
#sudo acpitool -s
