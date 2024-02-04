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
alias arnet="ssh -p2323 root@10.0.0.1"

alias ytdl="~/bin/youtube-dl -x --audio-format=mp3 --audio-quality=0"
alias sail="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 defaultuser@xperia0:/home/defaultuser /mnt/nemo"
alias ff="LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 cpulimit -l 50 -k firefox"
#weather
alias weather="curl -s wttr.in/Yerevan | head -n -1"
export BEOPLAY="00:12:6F:15:06:DD"
alias bmplayer='mplayer -ao alsa:device=bluealsa'
alias bchrom='google-chrome-stable --alsa-output-device=bluealsa'
alias bchromi='chromium --alsa-output-device=bluealsa'

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


#export ALSA_CARD=1
#export ALSA_PCM_CARD=1
#export ALSA_CTL_CARD=1
#export MC_SKIN=MC_SKIN=modarcon16-defbg
#export MC_SKIN=MC_SKIN=modarin256
#alias mc="mc -S modarcon16-defbg"
#alias mc="mc -S modarin256"
export EDITOR="vim"
export PATH="/u/inky/bin:/opt/voc/bin:/u/inky/local/bin:$PATH:/opt/oo2c/bin:/opt/cc65/bin:/opt/cvs-fast-export/bin"
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

#clean copy buffer
alias cclean="xsel -bc"
alias cclean1="touch /tmp/blank && xclip -selection clipboard /tmp/blank"

#mplayer
#aplay -l
#mplayer -ao alsa:device=hw=1.0 groovy.mp3

#mplayer tv:// gives you stream from default web cam.
#mplayer -tv device=/dev/video1:driver=v4l2 tv://

alias mars="sudo screen /dev/ttyUSB1  115200"

alias ydl="~/bin/yt-dlp_linux -x --audio-format mp3 --audio-quality 0 "



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
stty werase ^p
#stty erase ^?
stty erase ^h
stty kill ^a

#pysstv
alias sstv0=". ~/pip/sstv/bin/activate"
alias sstv="pysstv --resize --keep-aspect-ratio"

#push tags
alias gpt="git push origin --tags"
alias gpom="git push origin master"

#mplayer, should be built with ladspa
alias mpl="mplayer -af scaletempo"

# invert screen
alias rotate="xrandr --output eDP1 -o invert"
alias rotateback="xrandr --output eDP1 -o normal"

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
[ -n "$XTERM_VERSION" ] && transset --id "$WINDOWID" >/dev/null


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

