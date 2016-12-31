functins to make animations from file lists, or generate those lists.

usage
====

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


* half_size()

arguments:

** $1 - some postfix, like "_small". if the input files look like "shot007.png" then output files will look like "shot007_small.png".

** $2 - input list.

** $3 - output list.

* quarter_size()

the same as the function above, but will create even smaller files.

example
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
gen_list shot png 23 42 $list

half_size _small $list $newlist

make_animation rain 15 $newlist

make_strob_animation rain 15 $newlist

rm -f $newlist
```

caller is responsible in removing temporary resized files.


