set -x
dirs=`ls -al | grep dr | awk {'print $9'} | tail -n +3`
luts="fujichrome_astia_100f_daylight.xmp  fujichrome_provia_100f.xmp"
for i in $luts
do
  for j in $dirs
  do
    cp $i $j
	cp to_all.sh $j
	cd $j
	bash to_all.sh
	cd ..
  done

done

