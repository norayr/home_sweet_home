source ./make_animation.sh

list=`gen_list _MG_ JPG 8452 8472`


echo $list
newlist=`quarter_size small $list`
newlist2=`quarter_size smaller $newlist`

make_animation test2 15 $newlist2
