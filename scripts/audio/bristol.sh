#https://spyurk.am/posts/3226265
#startBristol -mini -audio alsa -audiodev plughw:2,0
startBristol  -prophet -audio alsa -audiodev plughw:2,0 -midi alsa -channel 1 -mididev /dev/midi1 &
sleep 3
aconnect 20:0 128:0
