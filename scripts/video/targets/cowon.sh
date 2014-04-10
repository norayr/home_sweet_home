name=${1%%.*}
#mencoder $1 -oac mp3lame -lameopts abr:br=64 -af volnorm -ovc lavc -lavcopts vcodec=mpeg4:vbitrate=640 -idx -ffourcc DIVX -ofps 13 -o $name-n810.avi


mencoder $1 -o $name-cowon.avi -ovc lavc -vf expand=aspect=4/3,scale=320:240 -oac mp3lame -lameopts abr:br=128 -af volnorm -lavcopts vmax_b_frames=0:vbitrate=256
#mencoder $1 -o $name-cowon.avi -ovc lavc -vf scale=320:240 -oac lavc -lavcopts vmax_b_frames=0:acodec=mp3:abitrate=128:vbitrate=256

#mencoder $1 -oac mp3lame -lameopts abr:br=64 -af volnorm -ovc lavc -lavcopts vcodec=mpeg4:aspect=4/3:vbitrate=640 -vf scale=480:360 -idx -ffourcc DIVX -ofps 13 -o $name-n810.avi
#mencoder dvd://5 -oac twolame -twolameopts br=64 -ovc lavc -lavcopts vcodec=mpeg4:aspect=4/3:vbitrate=512 -vf scale=480:288 -idx -ffourcc DIVX -quiet -o whatever.avi 

