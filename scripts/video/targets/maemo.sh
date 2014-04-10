name=${1%%.*}
mencoder $1 -oac mp3lame -lameopts abr:br=64 -af volnorm -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=640 -idx -ffourcc DIVX -ofps 13 -o $name-n810.avi
#mencoder $1 -oac mp3lame -lameopts abr:br=64 -af volnorm -ovc lavc -lavcopts vcodec=mpeg4:aspect=4/3:vbitrate=640 -vf scale=480:360 -idx -ffourcc DIVX -ofps 13 -o $name-n810.avi
#mencoder dvd://5 -oac twolame -twolameopts br=64 -ovc lavc -lavcopts vcodec=mpeg4:aspect=4/3:vbitrate=512 -vf scale=480:288 -idx -ffourcc DIVX -quiet -o whatever.avi 

