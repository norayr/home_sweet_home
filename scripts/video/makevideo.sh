nm=${1%.*}
# showwaves
ffmpeg -i $1 -filter_complex "[0:a]showwaves=s=1280x720:mode=line:rate=25,format=yuv420p[v]" -map "[v]" ${nm}_showspectrum.mp4

#ffplay -f lavfi "amovie=$1 , asplit [a][out1]; [a] showwaves [out0]"

# showspectrum

#ffmpeg -i $1 -filter_complex "[0:a]showspectrum=s=1280x720,format=yuv420p[v]" -map "[v]" -map 0:a ${nm}_showspectrum.mp4

#ffplay -f lavfi "amovie=$1, asplit [a][out1]; [a] showspectrum=mode=separate:color=intensity:slide=1:scale=cbrt [out0]"

# showvolume
#ffmpeg -i $1 -filter_complex "[0:a]showvolume=f=1:b=4:w=720:h=68,format=yuv420p[vid]" -map "[vid]" -map 0:a ${nm}_showvolume.mp4

#ffplay -f lavfi "amovie=$1, asplit [a][out1]; [a] showvolume=f=255:b=4:w=720:h=68 [out0]"

# showfreqs

ffmpeg -i $1 -filter_complex "[0:a]showfreqs=mode=line:fscale=log,format=yuv420p[v]" -map "[v]" -map 0:a ${nm}_showfreqs.mp4

# ffplay -f lavfi "amovie=$1, asplit [a][out1]; [a]  showfreqs=mode=line:fscale=log [out0]"

# showcqt

ffmpeg -i $1 -filter_complex "[0:a]showcqt,format=yuv420p[v]" -map "[v]" -map 0:a ${nm}_showcqt.mp4

# ffplay -f lavfi "amovie=$1, asplit [a][out1]; [a] showcqt [out0]"

# avectroscope

ffmpeg -i $1 -filter_complex "[0:a]avectorscope=s=1280x720,format=yuv420p[v]" -map "[v]" -map 0:a ${nm}_avectroscope.mp4

# ffplay -f lavfi "amovie=$1 , asplit [a][out1]; [a] avectorscope=zoom=1.3:rc=2:gc=200:bc=10:rf=1:gf=8:bf=7 [out0]"

# aphasemeter

ffmpeg -i  $1 -filter_complex "[0:a]aphasemeter=s=1280x720:mpc=cyan,format=yuv420p[v]" -map "[v]" -map 0:a ${nm}_aphasemeter.mp4

# ffplay -f lavfi "amovie=$1, asplit [a][out1]; [a] aphasemeter=s=1280x720:mpc=cyan [out0]"

# ahistogram

ffmpeg -i $1 -filter_complex "[0:a]ahistogram,format=yuv420p[v]" -map "[v]" -map 0:a  ${nm}_ahistogram.mp4

# ffplay -f lavfi "amovie=$1, asplit [a][out1]; [a] ahistogram [out0]"

