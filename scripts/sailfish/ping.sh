for i in {1..254}
do
  sudo ping -c 1 -W 1 192.168.1.$i | grep -i "from"
done
