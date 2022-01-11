#!/bin/bash

# set display resolution and position
if [ "$(systemd-detect-virt)" == "none" ]; then
    xrandr --output DP-0 --primary --mode 2560x1440 --rate 165 --primary --output DP-2 --right-of DP-0 --mode 3440x1440 --rate 120
elif [ "$(systemd-detect-virt)" == "kvm" ]; then
    xrandr --output Virtual-1 --primary --mode 1920x1080 --rate 60 --primary
    /usr/bin/spice-vdagent
elif [ "$(systemd-detect-virt)" == "oracle" ]; then
    xrandr --output VGA-1 --primary --mode 1920x1080 --rate 60 --primary
    VBoxClient-all
fi

# load keyboard modmap
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# start seafile applet
/usr/bin/seafile-applet

# start dwm
~/.config/dwm-bar/dwm_bar.sh > .dwm-bar.log 2>&1 &
exec dwm > ~/.dwm.log
