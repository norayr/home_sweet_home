#first argument - name of the output gif
#second argument - delay
#next arguments - list of files to make animation from them.
set -x
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
  function gen_list()
  {
  list=""
  for i in `seq $3 $4`
  do
	#newnumber='00000'${i#foo}      # get number, pack with zeros
	#newnumber=${newnumber:(-5)}       # the last five characters
    #number=`printf ${1}%04d.${2} $i` #mplayer shots look like shot0042.png
    number=`printf %04d $i`
	item="${1}${number}.${2}"
	echo $item
	#list="$list $item"

  done
  #$5=$list 
  }

  # creates files with half size of the originals and returns the file list.
  # arguments:
  # $1 - postfix, like "half" or "small" or "sm"
  # $2 - input list
  # caller is encouraged to remove temporary files after using them.

  function half_size()
  {
  #creating input list and finding postfix
  input=""
  for i in $@
  do

    if [[ "$i" == "$1" ]]
    then
      postfix=$i 
    else
      input="${input} ${i}"
    fi

  done

  output=""

  for i in $input
  do
    
	#filename=$(basename "$fullfile")
	extension="${i##*.}"
	filename="${i%.*}"
    newfilename="${filename}_${postfix}.${extension}"
    convert -resize %50 $i ${newfilename}
    output="${output} ${newfilename}"
    echo ${newfilename}
  done

    $1=$output

  }

  function quarter_size()
  {
  #creating input list and finding postfix
  input=""
  for i in $@
  do

    if [[ "$i" == "$1" ]]
    then
      postfix=$i 
    else
      input="${input} ${i}"
    fi

  done

  output=""

  for i in $input
  do
    
	#filename=$(basename "$fullfile")
	extension="${i##*.}"
	filename="${i%.*}"
    newfilename="${filename}_${postfix}.${extension}"
    convert -resize %25 $i ${newfilename}
    output="${output} ${newfilename}"
    echo ${newfilename}
  done

    $1=$output

  }

  function eighth_size()
  {
  #creating input list and finding postfix
  input=""
  for i in $@
  do

    if [[ "$i" == "$1" ]]
    then
      postfix=$i 
    else
      input="${input} ${i}"
    fi

  done

  output=""

  for i in $input
  do
    
	#filename=$(basename "$fullfile")
	extension="${i##*.}"
	filename="${i%.*}"
    newfilename="${filename}_${postfix}.${extension}"
    convert -resize %12.5 $i ${newfilename}
    output="${output} ${newfilename}"
    echo ${newfilename}
  done

    $1=$output

  }

  function sixteenth_size()
  {
  #creating input list and finding postfix
  input=""
  for i in $@
  do

    if [[ "$i" == "$1" ]]
    then
      postfix=$i 
    else
      input="${input} ${i}"
    fi

  done

  output=""

  for i in $input
  do
    
	#filename=$(basename "$fullfile")
	extension="${i##*.}"
	filename="${i%.*}"
    newfilename="${filename}_${postfix}.${extension}"
    convert -resize %6.25 $i ${newfilename}
    output="${output} ${newfilename}"
    echo ${newfilename}
  done

    $1=$output

  }

# assumes that prefix is 'shot', postfix - '_small', extension - 'png'.
# arguments:
# $1 - output file name
# $2 - initial number of screenshot
# $3 - last number of screenshot
# $4 - delay

function animate_mplayer_screenshots()
{
start_frame=$2
end_frame=$3
lst=`gen_list shot png $start_frame $end_frame`
newlst=`half_size small $lst`
make_animation $1 $4 $lst
make_strob_animation ${1}_ $4 $lst
make_animation ${1}_small $4 $newlst
make_strob_animation ${1}_small_ $4 $newlst
rm -f $newlst
}

