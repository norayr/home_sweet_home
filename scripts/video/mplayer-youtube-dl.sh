#found at https://www.yonamine.dev/2012/10/how-to-use-youtube-dl-mplayer-to-stream.html
#https://www.yonamine.dev/2014/09/how-to-use-curl-youtube-dl-mplayer-to.html
#mplayer -ontop -cookies -cookies-file ./cookie.txt $(youtube-dl -gf 34 --cookies ./cookie.txt "https://www.youtube.com/watch?v=<VIDEO ID>")
#youtube-dl -o - | mplayer -
curl --ciphers RC4-SHA "$(youtube-dl -g https://www.youtube.com/watch?v=<VIDEO ID>)" | mplayer -
