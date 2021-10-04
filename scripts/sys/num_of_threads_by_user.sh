uid=`id $1 | awk {' print $1 '} | awk -F '=' {' print $2 '} | awk -F "(" {' print $1 '}`
ps -eLf| grep $uid | wc -l
