set -x
for port in /dev/ttyUSB*; do
    echo "Testing $port..."
    #echo -e "AT\r" > $port && sleep 1
    echo -e "AT\r" > $port
    if grep -q "OK" $port; then
        echo "Modem AT command interface found on $port"
        break
    fi
done

