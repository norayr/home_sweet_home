infile="tile.png"

h2=`convert $infile -format "%[fx:round(h/2)]" info:`

convert $infile \( -clone 0 -roll +0+$h2 \) +append -write mpr:sometile +delete -size 1920x1080 tile:mpr:sometile output.png

echo "add 'wmsetbg /path/to/output.png' to ~/GNUstep/Library/WindowMaker/autostart' file.
