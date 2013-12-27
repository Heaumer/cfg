#!/bin/sh

# load decent keymap
setxkbmap fr bepo
xmodmap ~/.Xmodmap

PATH=$PATH:$HOME/plan9/bin/

# launch the plumber
9 plumber

# launch urxvtd if needed
( ps aux | grep urxvtd | grep -v grep ) || urxvtd -q -f -o

$WM &
dwm&
p=$!

# in case wheel-click has been disabled..
# xinput set-prop "AlpsPS/2 ALPS GlidePoint" "Evdev Middle Button Emulation" 1

wait $p
