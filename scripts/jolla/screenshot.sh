dbus-send --session --print-reply --dest=org.nemomobile.lipstick /org/nemomobile/lipstick/screenshot org.nemomobile.lipstick.saveScreenshot string:"/home/nemo/Pictures/Screenshot-$(date +%y-%m-%d-%H-%M-%S).png"
