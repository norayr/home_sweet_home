#xa2
sudo ifconfig usb0 192.168.2.12
sshfs defaultuser@192.168.2.15:/home/defaultuser /mnt/nemo
sshfs nemo@192.168.2.15:/run/media/defaultuser/ae47bf37-c663-4602-bc9e-ed455c441ab9 /mnt/nemo


#jolla 1
sudo ifconfig usb0 192.168.2.12
sshfs nemo@192.168.2.15:/home/nemo /mnt/nemo
sshfs nemo@192.168.2.15:/run/media/nemo/ae47bf37-c663-4602-bc9e-ed455c441ab9 /mnt/nemo

