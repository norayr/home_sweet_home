#found at https://www.yonamine.dev/2012/10/how-to-use-youtube-dl-mplayer-to-stream.html
mplayer -ontop -cookies -cookies-file ./cookie.txt $(youtube-dl -gf 34 --cookies ./cookie.txt "https://www.youtube.com/watch?v=<VIDEO ID>")
