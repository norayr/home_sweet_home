functins to make animations from file lists, or generate those lists.

usage
====

```
source ./make_animation.sh
```

functions
=========

* make_animation()

takes following args:
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

example
=======

to get list of files:

```
gen_list shot png 23 42 list
```
to make gif from them:

```
make_animation rain 15 $list
```

that is all folks.

