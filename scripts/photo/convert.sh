files=`ls *.JPG`
for i in $files
do
basename=${i%.*}
convert -resize 800x533 $i $basename.JpG
curves "0,0 25,15 50,50 75,85 100,100" $basename.JpG $basename.jpg
rm $basename.JpG
done

