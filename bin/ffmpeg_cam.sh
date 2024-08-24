LUT="dhnc/fujichrome-provia-100f.png"
#LUT="dehancer-agfa-100.png"
#ffmpeg -f v4l2 -i /dev/video0 -i ${LUT} -filter_complex "[0:v][1:v]haldclut" -f v4l2 /dev/video2
#15 frames
ffmpeg -f v4l2 -i /dev/video0 -i hald-clut.png -filter_complex "[0:v][1:v]haldclut" -r 5 -f v4l2 /dev/video2

#drop frames when necessary
#ffmpeg -f v4l2 -i /dev/video0 -i ${LUT} -filter_complex "[0:v][1:v]haldclut,fps=fps=15" -f v4l2 /dev/video2

#doas ffmpeg -hwaccel auto -f v4l2 -i /dev/video0 -i hald-clut.png -filter_complex "[0:v][1:v]haldclut" -c:v libx264 -f v4l2 /dev/video2



