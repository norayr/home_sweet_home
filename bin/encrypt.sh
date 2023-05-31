INP="/tmp/a.txt"
OUTP="/tmp/a_`date -I`"
RCTP="email@something.com"
gpg --armour --output ${OUTP}.asc --encrypt --recipient ${RCPT} ${INP}

