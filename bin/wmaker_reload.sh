PID=`ps aux | grep 'wmaker --for-real'`
kill -s SIGUSR1 $PID
