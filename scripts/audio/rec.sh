if [ $# -eq 0 ]
then
  echo "No arguments supplied"
  sox -t alsa default /tmp/tmp.ogg
else
  sox -t alsa default $1
fi
