NET=2.2.2
for i in {1..254}
do 
  (ping ${NET}.$i -c 1 -w 5  >/dev/null && echo "${NET}.$i" &) ;
done

#nmap -sP 192.168.1.1-254
