for i in *.dng
do
  j="${i%.*}"
  ufraw-batch --wb=auto --out-type=tiff --out-depth=16 --clip=film --output=${j}_ufraw.tiff $i
  ufraw-batch --wb=auto --out-type=jpg --compression=93 --out-depth=16 --clip=film --output=${j}_ufraw.jpg $i
done

