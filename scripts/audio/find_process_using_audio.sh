echo $( \
    lsof +D /dev -F rt \
    | awk '/^p/ {pid=$1} /^t/ {type=$1} /^r0x(74|e)..$/ && type == "tCHR" {print pid}' \
    | cut -c 2- \
    | uniq \
)
