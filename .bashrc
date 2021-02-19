# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi


# Put your fun stuff here.
alias arnet="ssh root@arnet.am"
alias arnetik="ssh root@192.168.1.2"
#alias amp="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 noch@arnet.am:/amp /amp"
alias amp="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 noch@arnet.am:/amp /amp"
alias ampik="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 root@192.168.1.2:/amp /amp"
alias ampir="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 noch@37.252.65.107:/disk0/ /ampir"
alias shekspir="ssh noch@37.252.65.107"
alias ff="cpulimit -l 20 -k firefox"
alias drop_all="sync; echo 3 > /proc/sys/vm/drop_caches"
#export PATH=$HOME/bin:$PATH:/local/bin:/opt/android-ndk/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86_64/bin
export LANG="hy_AM.UTF-8"
export LC_ALL="hy_AM.UTF-8"
#export ALSA_CARD="1"
#export ALSA_PCM_CARD="1"
#export ALSA_CTL_CARD="1"
export PATH="/opt/voc/bin:$PATH"
export DIARY_DIR=/home/noch/diary
export EDITOR=vim
export MC_SKIN="modarcon16-defbg"
#alias mc="mc -S modarcon16-defbg"
alias cssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias alb="album -medium=1000x -theme simple2"
alias ydl="youtube-dl -x --audio-format=mp3 --audio-quality=0"
alias weather="curl -s wttr.in/Yerevan | head -n -1"
export BEOPLAY="00:12:6F:15:06:DD"
alias bmplayer='mplayer -ao alsa:device=bluealsa'
alias bchrom='google-chrome-stable --alsa-output-device=bluealsa'
alias bchromi='chromium --alsa-output-device=bluealsa'
alias drop_all="sudo sync; sudo bash echo 3 > /proc/sys/vm/drop_caches"
alias r="sudo"
alias afox="APULSE_CAPTURE_DEVICE="plughw:1,0" apulse firefox-bin"
#gentoo
alias eworld="emerge -avuND @world"
alias eclean="emerge --depclean -a"
alias ecleanmoar="eclean-dist --deep"
export BROWSER=/usr/bin/seamonkey
#PS1='[\D{%F %T} \u@\h \W]\$ '
#PS1='[\D{%F %T}] \$ '
#PS1='\[\033[01;34m\][\D{%F %T}] \$ '
PS1='\[\033[01;34m\][\D{%F %T}] \$ \[\033[00;37m\]'
#PS1='\[\033[01;32m\][\D{%F} \[\033[01;34m\] \D{%T}] \$ \[\033[00;37m\]'
#PS1='\[\033[01;32m\]\D{%F} \[\033[01;34m\]\D{%T} \$ \[\033[00;37m\]'


#color names
#https://invisible-island.net/xterm/xterm.faq.html#color_by_number

#how to change palette
#https://stackoverflow.com/questions/27159322/rgb-values-of-the-colors-in-the-ansi-extended-colors-index-17-255

#black
echo -en "\e]4;0;#2e3440\e\\"
#echo -en "\e]4;0;#4c566a\e\\"
#red
echo -en "\e]4;1;#b26a7d\e\\"
#green
echo -en "\e]4;2;#97ba97\e\\"
#yellow
echo -en "\e]4;3;#c2c270\e\\"
#blue
echo -en "\e]4;4;#81a1c1\e\\"
#magenta
echo -en "\e]4;5;#b48ead\e\\"
#cyan
echo -en "\e]4;6;#87c0d0\e\\"
#white
echo -en "\e]4;7;#dbe0ea\e\\"
#color8 gray30
#color9 red
echo -en "\e]4;9;#b26a7d\e\\"
#color10 green
echo -en "\e]4;10;#97ba97\e\\"
#color11 yellow
echo -en "\e]4;11;#c2c270\e\\"
#color12 blue
echo -en "\e]4;12;#81a1c1\e\\"
#color13 magenta
echo -en "\e]4;13;#b48ead\e\\"
#color14 cyan
echo -en "\e]4;14;#87c0d0\e\\"
#color15 white
echo -en "\e]4;15;#dbe0ea\e\\"

