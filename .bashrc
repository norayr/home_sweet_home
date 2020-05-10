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
#alias amp="sshfs noch@arnet.am:/amp /amp"
alias amp="sshfs noch@arnet.am:/amp /amp"
alias ampik="sshfs root@192.168.1.2:/amp /amp"
alias ampir="sshfs noch@37.252.65.107:/disk0/ /ampir"
alias shekspir="ssh noch@37.252.65.107"
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
alias r="sudo"
export BROWSER=/usr/bin/seamonkey
#PS1='[\D{%F %T} \u@\h \W]\$ '
#PS1='[\D{%F %T}] \$ '
#PS1='\[\033[01;34m\][\D{%F %T}] \$ '
#PS1='\[\033[01;34m\][\D{%F %T}] \$ \[\033[00;37m\]'
#PS1='\[\033[01;32m\][\D{%F} \[\033[01;34m\] \D{%T}] \$ \[\033[00;37m\]'
PS1='\[\033[01;32m\]\D{%F} \[\033[01;34m\]\D{%T} \$ \[\033[00;37m\]'
