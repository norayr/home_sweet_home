# example usage

. ./make_animation.sh


# drawing
animate_mplayer_screenshots gif/drawing 70 85 16

# or alternatively the same
#list=`gen_list shot png 70 85`
#newlist=`half_size small $list`
#make_animation gif/drawing 16 $list
#make_strob_animation gif/drawing_ 16 $list
#make_animation gif/drawing_small 16 $newlist
#make_strob_animation gif/drawing_small_ 16 $newlist
#rm -f $newlist

