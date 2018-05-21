for i in `ipcs -m | awk '/noch/ {print $2}'`; do (ipcrm -m $i); done 
