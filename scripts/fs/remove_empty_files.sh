find . -type f -size 0k -exec rm {} \; | awk '{ print $8 }'

