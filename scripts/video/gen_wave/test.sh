INPUT="-i ishome-friend.mp3"
IMG=test.jpg
FONT='/home/inky/.fonts/SyntaxLTStd-Black.otf'
SIZE="15"
SIZE="5"
RES='1920x1080'
RES='800x600'
#wave
WAVE='1920x480'
WAVE='800x100'
OVER='600'
OVER='450'
# from here: https://ffmpeg.org/ffmpeg-filters.html
WVTP="cline"
#WVTP="line"
#WVTP="point"
#WVTP="p2p"
#txt
X=1600
X=600
Y=80

#RES='800x600'
#colors here: https://man.archlinux.org/man/ffmpeg-utils.1.en
#COLOR=SteelBlue
#COLOR=DarkSlateBlue
#COLOR=DarkSeaGreen
#COLOR=DeepSkyBlue
#COLOR=DimGray
#COLOR=DodgerBlue
#COLOR=Indigo
#COLOR=Fuchsia
#COLOR=Gainsboro
COLOR=GhostWhite
#COLOR=LightGrey
#COLOR=LightYellow
#COLOR=GreenYellow
#COLOR=MidnightBlue


OUT=out.mp4
#INPUT=" -f alsa -ac 2 -sample_rate 44100 -thread_queue_size 4096 -i default:CARD=Rmx2"
#ffmpeg -i ${INPUT} \
#  -f alsa -ac 2 -sample_rate 44100 -thread_queue_size 4096 -i default:CARD=Rmx2 \
#  -i ${IMG}  -filter_complex \
# [0:a]afade=t=in:st=64:d=15[a]; \
#[0:a]showwaves=mode=cline:s=${WAVE}:colors=${COLOR}@0.9|DarkOrchid@0.8:scale=cbrt:r=25[waves]; \
  # [0:a]showwaves=mode=${WVTP}:s=${WAVE}:colors=${COLOR}:scale=cbrt:r=25[waves]; \
#[0:a]showspectrum=mode=combined:s=${WAVE}:color=channel:scale=cbrt[waves]; \

ffmpeg ${INPUT} -i ${IMG} -ss 00:00:00   -filter_complex \
 "[1:v]scale=${RES}[image]; \
  [0:a]afade=t=in:st=0:d=1[a]; \
  [image][waves]overlay=0:${OVER}[bg]; \
  [0:a]showwaves=mode=${WVTP}:s=${WAVE}:colors=${COLOR}:scale=lin:r=25[waves]; \
 [bg]drawtext=fontfile=${FONT}:fontsize=${SIZE}:timecode='00\:00\:00\:00':rate=25:fontsize=65:fontcolor='white':boxcolor='black':box=1:x=${X}-text_w/2:y=${Y}[out]" \
  -map "[out]" -map [a] \
  -c:v libx264 -preset fast -crf 18 -c:a aac -b:a 128k  ${OUT}
