vol=`amixer get Master | grep % | awk {'print $4'} | awk '{ print substr( $0, 2, 2 ) }'`
amixer set Master 30%
aplay $1
amixer set Master $vol
