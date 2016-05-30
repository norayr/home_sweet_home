ffmpeg -loop 1 -i 1.jpg -i without_love.mp3 -c:v libx264 -c:a copy -shortest out.mp4
