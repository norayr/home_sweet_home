for i in `ipcs -s | awk '/noch/ {print $2}'`; do (ipcrm -s $i); done 
