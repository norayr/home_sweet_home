#tab2csv
#sed 's/\t/,/g' file.tsv > file.csv
#whitespace and tab to csv
#sed 's/\s/,/g' $1 > ${1}.csv
#same but encloses to brackets the rest
sed -e 's/"/\\"/g' -e 's/\s/","/g' -e 's/^/"/' -e 's/$/"/' $1 > ${1}.csv


