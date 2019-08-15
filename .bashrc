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

#export PATH=$HOME/bin:$PATH:/local/bin:/opt/android-ndk/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86_64/bin
export LANG="hy_AM.UTF-8"
export LC_ALL="hy_AM.UTF-8"
#export ALSA_CARD="1"
#export ALSA_PCM_CARD="1"
export PATH="/opt/voc/bin:$PATH"
export DIARY_DIR=/home/noch/diary
export EDITOR=vim
#export MC_SKIN=MC_SKIN=modarcon16-defbg
alias mc="mc -S modarcon16-defbg"
