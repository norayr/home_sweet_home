set -x
device_id=""
omemo_fingerprint=""
#now strip whitespaces
omemo_fingerprint_stripped=`echo ${omemo_fingerprint} | sed 's/ //g'`
user="user"
domain="domain.tld"
str="xmpp:${user}@${domain}?omemo-sid-${device_id}=${omemo_fingerprint_stripped}"
qrencode -o psi_${deviceid}.png $str
