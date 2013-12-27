#!/bin/bash

PLAN9=$HOME/plan9

GOROOT=$HOME/go
GOOS=linux
GOARCH=386
GOBIN=$GOROOT/bin/

PATH=/bin:/usr/bin:/usr/local/bin
PATH=/usr/share/texmf/bin/:$PATH
PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin
PATH=$HOME/cfg/bin/:$GOBIN:$PATH:$PLAN9/bin
PATH9=$PLAN9/bin:$PATH
PATHU=$PATH

MANPATH=$MANPATH:/usr/local/share/man/

export PLAN9 GOROOT GOOS GOARCH GOBIN PATH MANPATH

WM=`which dwm`
export WM

PS1="($(hostname))% "
export PS1

updatep9p() {
	cd $PLAN9
	hg pull -u
	./INSTALL
}

updatego() {
	cd $GOROOT/src
	hg pull
	hg update release
	./all.bash
}

tomp3() {
	ext=`echo "$1" | sed 's/.*\.\([^\.]*\)$/\1/'`
	mplayer -vo null -vc dummy -af resample=44100 -ao pcm:nowaveheader:file=/dev/stdout "$1" |\
	lame -h - "${1%$ext}mp3"
}

cd() {
	if [ "$1" == "" ]; then
		builtin cd $HOME;
	else
		builtin cd "$*"
	fi
	[ "$winid" != "" ] && awd
}

alias ds='du -sh'
alias dh='df -h'
alias lh='/usr/bin/ls -lh'
alias ll='/usr/bin/ls -l'

alias gst='git status'
alias ga='git add'

alias vbox='/opt/VirtualBox/VirtualBox'

bind '\C-w:backward-kill-word'

