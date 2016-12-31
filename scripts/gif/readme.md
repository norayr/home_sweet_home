functins to make animations from file lists, or generate those lists.

using
====

to use it, "import" it.

```
source ./make_animation.sh
```

functions
=========

* make_animation()

arguments:

** name of the output gif file.

** delay

** list of files

usage:
```
make_animation rain 16 $list
```

* make_strob_animation()

the function differs from the previous one in that it only uses every second file from the list.


* gen_list()

this function is useful to make animations by only mentioning mplayer screenshot numbers.

let's say we want to make an animation from the files shot0023.png .. shot0042.png. for that we call gen_list() by giving it two numbers, i. e. 23 and 42 and get the list as the return value.

arguments:

** prefix (i. e. "shot")

** extension (i. e. "png")

** first number

** last number

** list to return

usage:
```
gen_list shot png 23 42 $list
```

* half_size()

arguments:

** $1 - some postfix, like "_small". if the input files look like "shot007.png" then output files will look like "shot007_small.png".

** $2 - input list.

usage:

```
newlist=`half_size "_small" $list`
```


* quarter_size()

the same as the function above, but will create even smaller files.

* animate_mplayer_screenshots()

this function will take the name of the output file and initial and last numbers of frames, and delay:

** $1 - output file name without extension
** $2 - initial number of frame
** $3 - last number of frame
** $4 - delay value

usage:

```
animate_mplayer_screenshots rain 23 42 16
```

examples
=======

to get list of files:

```
gen_list shot png 23 42 $list
```
to make gif from them:

```
make_animation rain 15 $list
```

will create rain.gif from the $list list.

```
make_strob_animation rain 15 $list
```

will create smaller output animation because it'll take only every second file.

it's possible to resize files before making an animation.

```
list=`gen_list shot png 70 85`
newlist=`half_size small $list`
make_animation gif/drawing 16 $list
make_strob_animation gif/drawing_ 16 $list
make_animation gif/drawing_small 16 $newlist
make_strob_animation gif/drawing_small_ 16 $newlist
rm -f $newlist
```

caller is responsible in removing temporary resized files.

or the same

```
animate_mplayer_screenshots gif/drawing 70 85 16
```

p. s.
in order to make screenshots, I use mplayer with ```-vf screenshot``` argument, then press 's' to make a screenshot. (:

