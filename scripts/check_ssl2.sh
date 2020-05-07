SRV=arnet.am
curl --insecure -v https://${SRV} 2>&1 | awk 'BEGIN { cert=0 } /^\* Server certificate:/ { cert=1 } /^\*/ { if (cert) print }'
