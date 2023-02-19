#!/bin/bash

# set display resolution and position
if [ "$(systemd-detect-virt)" == "none" ]; then
    xrandr --output DP-0 --primary --mode 2560x1440 --rate 165 --scale 1x1 --output DP-2 --right-of DP-0 --mode 3440x1440 --rate 120 --scale 1x1 --output HDMI-0 --off
elif [ "$(systemd-detect-virt)" == "kvm" ]; then
    xrandr --output Virtual-1 --primary --mode 1920x1080 --rate 60
    /usr/bin/spice-vdagent
elif [ "$(systemd-detect-virt)" == "oracle" ]; then
    xrandr --output Virtual1 --primary --mode 1920x1080 --rate 60
    VBoxClient-all
elif [ "$(systemd-detect-virt)" == "vmware" ]; then
    vmware-user &
fi

# load keyboard modmap
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# needed for seahorse keyring
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# start applets
/usr/bin/nm-applet &
/usr/bin/flameshot &

# start dwm
pkill dwm-bar.sh; ~/.config/dwm-bar/bar.sh &
exec dwm
