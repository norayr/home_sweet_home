if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    srv=spyurk.am
else
    srv=$1
fi
echo "checikng $srv"
echo | openssl s_client -showcerts -servername $srv -connect $srv:443 2>/dev/null | openssl x509 -inform pem -noout -text | grep "Not After"
