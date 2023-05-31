if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    srv=spyurk.am
else
    srv=$1
fi
echo "checikng $srv"
openssl s_client -connect $srv:443 < /dev/null 2>/dev/null | openssl x509 -fingerprint -noout -in /dev/stdin
