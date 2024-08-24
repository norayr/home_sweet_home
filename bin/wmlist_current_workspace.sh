current_workspace=$(wmctrl -d |wmctrl -d | awk '/\*/ {print $1}')
wmctrl -l | awk -v workspace="$current_workspace" '$2 == workspace'

