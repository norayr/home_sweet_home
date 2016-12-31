#first argument - name of the output gif
#second argument - delay
#next arguments - list of files to make animation from them.

function make_animation()
{
  list=""

  for i in $@
  do

    if [[ "$i" == "$1" ]]
	then
      outname=$i
	elif [[ "$i" == "$2" ]]
	then
      delay=$i
	else
      list="${list} ${i}"
	fi

  done

  convert -loop 0 -delay $delay $list $outname.gif

}

function make_strob_animation()
{
  list=""
  j=0
  for i in $@
  do

    if [[ "$i" == "$1" ]]
	then
      outname=$i
	elif [[ "$i" == "$2" ]]
	then
      delay=$i
	else
      # this way we add only every second image to the list.
      let "j++"

      if [ $((j%2)) -eq 0 ];
      then
        #echo "even";
        list="${list} ${i}"
      #else
        #echo "odd";
      fi
   	fi

  done

  convert -loop 0 -delay $delay $list $outname.gif

}

  #first argument - prefix, like "shot"
  #second argument - file extension, like "png"
  #third argument - first number
  #fourth argument - last number
  #fifth argument - list to return
  function gen_list()
  {
  list=""
  for i in `seq $3 $4`
  do
	#newnumber='00000'${i#foo}      # get number, pack with zeros
	#newnumber=${newnumber:(-5)}       # the last five characters
    #number=`printf ${1}%04d.${2} $i` #mplayer shots look like shot0042.png
    number=`printf %04d $i`
	list="$list ${1}${number}.${2}"

  done
  $4=$list 
  }

