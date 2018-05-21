# find files that have been
# modified at
find . -type f -newermt 2007-06-07 ! -newermt 2007-06-08
# accessed at
find . -type f -newerat 2008-09-29 ! -newerat 2008-09-30
# permission changed at
find . -type f -newerct 2008-09-29 ! -newerct 2008-09-30

