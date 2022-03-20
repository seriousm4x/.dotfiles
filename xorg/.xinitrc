#!/bin/bash

# set display resolution and position
if [ "$(systemd-detect-virt)" == "none" ]; then
    xrandr --output DP-0 --primary --mode 2560x1440 --rate 165 --scale 1x1 --primary --output DP-2 --right-of DP-0 --mode 3440x1440 --rate 120 --scale 1x1 --output HDMI-0 --off
elif [ "$(systemd-detect-virt)" == "kvm" ]; then
    xrandr --output Virtual-1 --primary --mode 1920x1080 --rate 60 --primary
    /usr/bin/spice-vdagent
elif [ "$(systemd-detect-virt)" == "oracle" ]; then
    xrandr --output VGA-1 --primary --mode 1920x1080 --rate 60 --primary
    VBoxClient-all
fi

# load keyboard modmap
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# start applets
/usr/bin/nm-applet &
/usr/bin/seafile-applet &
/usr/bin/flameshot &

# start dwm
~/.config/dwm-bar/bar.sh &
exec dwm
