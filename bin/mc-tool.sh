server=spyurk.am
id=norayr
jid=${id}@${server}

jid_pw='mystrongpassword'


keyring_init() {
  [ # -d ~/.config/mate/keyrings ] && mkdir -p ~/.config/mate/keyrings && chmod 700 ~/.config/mate/keyrings
  cat > ~/.config/mate/keyrings/Default_keyring.keyring << EOF
[keyring]
display-name=Default keyring
ctime=\$(date +%s)
mtime=0
lock-on-idle=false
lock-after=false

EOF

  echo "Default_keyring" > ~/.config/mate/keyrings/default
  chmod 600 ~/.config/mate/keyrings/Default_keyring.keyring
  chmod 600 ~/.config/mate/keyrings/default

}

jid_add() {
  account_id=$(echo ${jid}|sed 's/\./_2e/g'|sed 's/\@/_40/g')
  for i in \$(mc-tool list |grep \${account_id});
  do
    mc-tool remove \$i
  done

  account=\$(mc-tool add gabble/jabber ${jid} string:account=${jid} string:password=${jid_pw} bool:require-encryption=true bool:ignore-ssl-errors=true)

  echo account=${account}

  mc-tool icon \${account} im-jabber

  mc-tool enable \${account}
}



