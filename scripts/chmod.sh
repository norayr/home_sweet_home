#directories
#find . -type d -exec chmod 755 {} +
#files
#find . -type f -exec chmod 644 {} +

#dirs
#chmod 755 $(find . -type d)

#file
#chmod 644 $(find . -type f)

find . -type d -print0 | xargs -0 chmod 755 
find . -type f -print0 | xargs -0 chmod 644

