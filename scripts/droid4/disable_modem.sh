# to ensure modem won't start after reboot
# rc-update del cellulard
doas busctl call org.ofono /motmdm_0 org.ofono.Modem SetProperty sv Powered b false


