set -x
#lurch
#deviceid="637435586"
#fingerprint
#ofs="0f3919a3d9adb6702520baa3b8e6571b0208f016b8b008fad4d3d7fcba04cf7e"

#psi lovelace
deviceid="1086263993"
of="1A01B407 7584CC5C 1D8EC044 D25C06A7 A187D374 52CE7B53 A7115041 78D00843"

#psi pinephone
deviceid="949848264"
of="A82FAFB0 143485D8 A542603F 2D027EA3 BE593BA0 0C351B55 0C8C25C5 97D2BE1A"


user="գրող"
domain="ծոց.հայ"
ofs=`echo ${of} | sed 's/ //g'`
str="xmpp:${user}@${domain}?omemo-sid-${deviceid}=${ofs}"
qrencode -o psi_${deviceid}.png $str

