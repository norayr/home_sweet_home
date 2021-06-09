IN=1-0002.avi
ffmpeg -ss 00:00:09 -to 00:04:49 -i $IN -acodec copy -vcodec copy -async 1 cut0.avi
#ffmpeg -ss 00:04:54 -to 00:08:35 -i $IN -acodec copy -vcodec copy -async 1 cut2.avi

