# let's say you have no access to some resource from the local computer, however the resource is accessible from your server.
# then let's setup a local proxy which would forward requests to your server.
# let it listen on 9070.

ssh -D9070 root@yourserver.am

# then you set your program - be it a browser, or pidgin, to use socks proxy on local host and above port.
# that's all folks.
