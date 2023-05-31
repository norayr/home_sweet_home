while true
do
  xdotool mousemove_relative -- 42 0
  xdotool click 1
  sleep 10
  xdotool mousemove_relative -- -42 0
  xdotool click 1
  sleep 10
done
