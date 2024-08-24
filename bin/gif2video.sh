#ffmpeg -i $1 -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 3.0 -movflags +faststart ${1}.mp4
#ffmpeg -i ${1} -vf "fps=1" -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 3.0 -movflags +faststart ${1}.mp4
# file loop.txt should contain 'file filename.gif' lines.
ffmpeg -f concat -safe 0 -i /tmp/loop.txt -c:v libx264 -pix_fmt yuv420p -profile:v baseline -level 3.0 -movflags +faststart output.mp4

#ffmpeg -i input.gif -i audio.mp3 -c:v libx264 -c:a aac -pix_fmt yuv420p -profile:v baseline -level 3.0 -movflags +faststart output.mp4

