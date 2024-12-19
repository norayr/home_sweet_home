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

# 2fa
# usage
# oathtool -b --totp=sha1 `cat file`
# or
# oathtool -b --totp=sha1 <hash>
alias oath="oathtool -b --totp=sha1"

#sizes
alias sizeoflong="cpp -dD /dev/null | grep __SIZEOF_LONG__"

#ignore history started with whitespace
export HISTIGNORE=' *'

alias blank="touch /tmp/blank && xclip -selection clipboard /tmp/blank"
#alias arnet="ssh root@arnet.am"
#alias arnet="ssh -p2323 root@10.0.0.1"
alias arnet="ssh -p2323 root@37.252.77.193"
alias step="ssh root@173.212.193.168"
#alias arnetroute="sudo route add -host 37.252.78.253 gw 192.168.1.1 dev wlan0"

alias sdf="ssh tanakian@tty.sdf.org"
alias arnetik="ssh root@192.168.1.2"
alias ytdl="~/bin/youtube-dl -x --audio-format=mp3 --audio-quality=0"
#alias amp="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 noch@arnet.am:/amp /amp"
alias amp="sudo wg-quick up arnet"
alias illuria="sudo wg-quick up illuria0"
alias fl="sudo mount 192.168.1.2:/mnt/floppy /mnt/floppy"
alias sail="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 defaultuser@xperia0:/home/defaultuser /mnt/nemo"
alias d4="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 user@192.168.6.118:/mnt /mnt/nemo"
#alias amp="mount -t nfs 10.0.0.1:/amp /amp"
#alias ampik="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 noch@192.168.1.2:/amp /amp"
alias admin="vncviewer 10.116.17.136:1"
alias cps="vncviewer 10.116.16.211:1"
alias ff="LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 cpulimit -l 50 -k firefox"
#weather
alias weather="curl -s wttr.in/Yerevan | head -n -1"
#gentoo
alias eworld="emerge -avuND @world"
alias eworld2="sudo -i emerge --deep --update --newuse --changed-use --with-bdeps=y --autounmask --autounmask-write @world"
alias eworld3="sudo -i emerge --newuse --update --ask --backtrack=9999 --deep --with-bdeps=y --regex-search-auto=y --verbose @world"
alias eclean="emerge --depclean -a"
alias ecleanmoar="eclean-dist --deep"
alias rshift="redshift -l 40.1833330:44.5166670 -b 0.7"
alias bitzone="ssh bitzone@tty.livingcomputers.org"
alias dd2="dd status=progress conv=fsync"
alias free_buffers="free && sync && echo 3 > /proc/sys/vm/drop_caches && free"
alias chm="chmod -R u=rwX,g=,o= ~/documents"

#gpg
alias decrypt="gpg --no-tty --command-fd 0 --passphrase-fd 0 --decrypt"
alias encrypt="gpg --armour --output Norayr_2023_106_A_weg.txt.asc --encrypt --recipient norayr@arnet.am Norayr_2023_106_A_weg.txt"


#snps
export ICAROOT="/u/inky/ICAClient/linuxx64"
#alias de02="ICAClient/linuxx64/wfica /tmp/REUwMkRDLkRFMDIgU2hhcmVkIFdpbmRvd3MgJFMyLTQ-.ica"
#alias de02="ICAClient/linuxx64/wfica /tmp/REUwMldJTkRDLkRFMDIgU2hhcmVkIFdpbmRvd3MgMTAgJFMxLTI-.ica"
#alias de02="ICAClient/linuxx64/wfica /tmp/REUwMldJTkRDLkRFMDIgU2hhcmVkIFdpbmRvd3MgMTAgJFMxLTI-.ica"
#alias de02="ICAClient/linuxx64/wfica /tmp/REUwMldEQy5ERTAyIFNoYXJlZCBXaW5kb3dzIDEwICRTMS0y.ica"
alias de02="ICAClient/linuxx64/wfica /tmp/REUwMldJTkRDLkRFMDIgU2hhcmVkIFdpbmRvd3MgMTAgJFMxLTI-.ic"
#alias de02l="ICAClient/linuxx64/wfica /tmp/REUwMkRDLkRFMDIgU2hhcmVkIExpbnV4ICRTMS0y.ica"
alias de02l="ICAClient/linuxx64/wfica /tmp/REUwMkNWQUQuREUwMiBTaGFyZWQgTGludXggNyAkUzUtOA--.ica"
alias snps="ICAClient/linuxx64/wfica /tmp/VVMwMURDLkdvb2dsZSBDaHJvbWUgLSBPMzY-.ica"
alias de02a="ICAClient/linuxx64/wfica /tmp/REUwMldEQy5ERTAyIFNoYXJlZCBXaW5kb3dzIDEwICRTMS0y.ica"
alias us01="ICAClient/linuxx64/wfica /tmp/VVMwMVdJTkRDLlVTMDEgU2hhcmVkIFdpbmRvd3MgMTAgJFMxLTI-.ica"
alias us01l="ICAClient/linuxx64/wfica /tmp/VVMwMUNWQURWREUuVVMwMSBPREMgVkRFIDcgJEExLTEtMUZCRjFDNzctMDAwMQ--.ica"
alias am047="ICAClient/linuxx64/wfica /tmp/QU0wNENWQUQuQU0wNCBTaGFyZWQgTGludXggNyAkUzEtMg--.ica"

#export ALSA_CARD=1
#export ALSA_PCM_CARD=1
#export ALSA_CTL_CARD=1
#export MC_SKIN=MC_SKIN=modarcon16-defbg
#export MC_SKIN=MC_SKIN=modarin256
#alias mc="mc -S modarcon16-defbg"
#alias mc="mc -S modarin256"
export EDITOR="vim"
export PATH="/u/inky/bin:/opt/voc/bin:/u/inky/local/bin:$PATH:/opt/oo2c/bin"
alias r="sudo"
alias rwget="wget -r -np -k -l 1"
alias bchromi='chromium --alsa-output-device=bluealsa'
alias bmplayer='mplayer -ao alsa:device=bluealsa'
alias sda1='sudo mount /dev/sda1 /mnt/floppy -o uid=5555,gid=5555'
alias sdb1='sudo mount /dev/sdb1 /mnt/floppy -o uid=5555,gid=5555'
alias xperias="sshfs defaultuser@xperia0:/run/media/defaultuser/ae47bf37-c663-4602-bc9e-ed455c441ab9 /mnt/nemo"
alias xperia="sshfs defaultuser@xperia0:/home/defaultuser /mnt/nemo"
#PS1='[\D{%F %T} \u@\h \W]\$ '
#PS1='[\D{%F %T}] \$ '
PS1='\[\033[01;34m\][\D{%F %T}] \$ \[\033[00;37m\]'
alias rdns1="ssh -p44200 root@rdns1"
alias rdns2="ssh -p44200 root@rdns2"

#clean copy buffer
alias cclean="xsel -bc"
alias cclean1="touch /tmp/blank && xclip -selection clipboard /tmp/blank"

#mplayer
#aplay -l
#mplayer -ao alsa:device=hw=1.0 groovy.mp3

#chromium
#chromium  --alsa-output-device=hw:0,1
alias afox="APULSE_CAPTURE_DEVICE="plughw:1,0" apulse firefox-bin"

#xterm colors
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

#tips
#vim
#delete spaces at the end of the line
#:%s/\s\+$//

#source /u/inky/local/pkg/github.com/vgratian/smog/bash-completion
export PATH=$HOME/cm3/bin:$PATH
#stty werase ^p
##stty erase ^?
#stty erase ^h
#stty kill ^a

#pysstv
alias sstv0=". ~/pip/sstv/bin/activate"
alias sstv="pysstv --resize --keep-aspect-ratio"

#push tags
alias gpt="git push origin --tags"
alias gpom="git push origin master"

#mplayer, should be built with ladspa
alias mpl="mplayer -af scaletempo"

GOARCH="amd64"
GOBIN=""
GOEXE=""
GOHOSTARCH="amd64"
GOHOSTOS="linux"
GOOS="linux"
GOPATH="/u/inky/go"
GORACE=""
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin

#transparency, requires transset and xcompmgr program
#[ -n "$XTERM_VERSION" ] && /usr/bin/transset --id "$WINDOWID" >/dev/null


#droid4
#Install the prerequisites¶
# sudo apt install i2c-tools¶

## Turn LED on in torch mode¶
alias ton="sudo i2cset -y 2 0x53 0x10 0x1a"¶

## Turn LED on in privacy indication mode¶
alias tonp="sudo i2cset -y 2 0x53 0x10 0x19"¶

## Turn LED off (in any mode)¶
alias toff="sudo i2cset -y 2 0x53 0x10 0x18"¶

## Use LED for doing a hella bright flash for some time once and then turn off¶
alias tonn="sudo i2cset -y 2 0x53 0x10 0x1b"
export LD_LIBRARY_PATH="/home/user/ofront_1.4/lib"


alias spaste="curl -F 'sprunge=<-' http://sprunge.us"
alias lli="xrandr --output DSI-1 --brightness"
alias type="xdotool type --delay 100 "
alias lli="xrandr --output DSI-1 --brightness "

