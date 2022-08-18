#set -x

function find_active_tab_from_list {
  local func_result=""
  for i in "$@"
  do
    res=`wmctrl -lx | grep Pidgin.Pidgin | grep ${i} | awk {' print $1 '}`
    if [[ -n "$res" ]]
    then
      #func_result=$i
      func_result=$res
    fi
  done
  echo "$func_result" 
}

function find_active_tab_from_list2 {
  read -a list <<< "$(printf "%s" "$@")"
  local func_result=""
  for i in "${list[@]}"
  do
    res=`wmctrl -l | grep " ${i}" | awk {' print $1 '}`
    if [[ -n "$res" ]]
    then
      #func_result=$i
      func_result=$res
    fi
  done
  echo "$func_result" 
}


function findWinbyName {
  local func_result=""
  res=`wmctrl -l | grep $1 | awk {' print $1 '}`
  func_result=$res
}

#pineWindow=("#pine64" "#pinetime" "#pinewatch" "#pinephone" "#pinebook")
#adaWindow=("#retro" "##forth" "#oberon" "#lazarus" "#pascal" "#ada" "#fpc")
#osWindow=("#gentoo-powerpc" "#hellosystem" "#plan9" "#" "#pascal" "#ada" "#fpc")
#
#win=$(find_active_tab_from_list "${pineWindow[@]}")
#echo $win
#wmctrl -i -r $win -t 3
#
#win=$(find_active_tab_from_list "${adaWindow[@]}")
#echo $win
#wmctrl -i -r $win -t 3
#

if [[ -z $1 ]]
then
  echo "provide config file name"
  exit
fi
set -x
X0=80
Y0=50
X1=850
Y1=50
W=700
H=800
var=0 #this is used to check for odd or not to put window on the left or right
while read line
do
  wrkSpc=`echo $line | awk -F ":" {' print $1'}`
  winLst=`echo $line | awk -F ":" {' print $2'}`
  win=$(find_active_tab_from_list2 "${winLst[@]}")
  if [ $((var%2)) -eq 0 ]
  then
    wmctrl -i -r $win -t $wrkSpc 
    wmctrl -i -r $win -e 0,$X0,$Y0,$W,$H 
  else
    wmctrl -i -r $win -t $wrkSpc
    wmctrl -i -r $win -e 0,$X1,$Y1,$W,$H
  fi
  var=$((var+1))
done < $1
