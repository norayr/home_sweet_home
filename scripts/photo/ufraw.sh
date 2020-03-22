#for i in *.dng
#do
j="${i%.*}"
  ufraw --out-type=jpg --compression=100 --out-depth=16 --clip=film --output=${j}_ufraw.jpg
#done

