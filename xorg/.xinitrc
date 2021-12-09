#!/bin/bash

# set display resolution and position
if [ "$(systemd-detect-virt)" == "none" ]; then
    xrandr --output DP-0 --primary --mode 2560x1440 --rate 165 --primary --output DP-2 --right-of DP-0 --mode 3440x1440 --rate 120
else
    xrandr --output Virtual-1 --primary --mode 1920x1080 --rate 60 --primary
fi

# load keyboard modmap
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# start dwm
~/.config/dwm-bar/dwm_bar.sh > .dwm-bar.log 2>&1 &
exec dwm > ~/.dwm.log
