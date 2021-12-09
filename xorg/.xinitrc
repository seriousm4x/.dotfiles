# set display resolution and position
xrandr --output DP-0 --primary --mode 2560x1440 --rate 165 --primary --output DP-2 --right-of DP-0 --mode 3440x1440 --rate 120

# load keyboard modmap
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# start seafile client
/usr/bin/seaf-cli

# create null sinks
pactl load-module module-null-sink sink_name=game
pactl load-module module-null-sink sink_name=spotify
sleep 2

# connect game sink
pw-jack jack_connect "game Audio/Sink sink Monitor:monitor_FL" "Starship/Matisse HD Audio Controller Analog Stereo:playback_FL"
pw-jack jack_connect "game Audio/Sink sink Monitor:monitor_FL" "Scarlett Solo (3rd Gen.) Analog Stereo:playback_FL"
pw-jack jack_connect "game Audio/Sink sink Monitor:monitor_FR" "Starship/Matisse HD Audio Controller Analog Stereo:playback_FR"
pw-jack jack_connect "game Audio/Sink sink Monitor:monitor_FR" "Scarlett Solo (3rd Gen.) Analog Stereo:playback_FR"

# connect spotify sink
pw-jack jack_connect "spotify Audio/Sink sink Monitor:monitor_FL" "Starship/Matisse HD Audio Controller Analog Stereo:playback_FL"
pw-jack jack_connect "spotify Audio/Sink sink Monitor:monitor_FL" "Scarlett Solo (3rd Gen.) Analog Stereo:playback_FL"
pw-jack jack_connect "spotify Audio/Sink sink Monitor:monitor_FR" "Starship/Matisse HD Audio Controller Analog Stereo:playback_FR"
pw-jack jack_connect "spotify Audio/Sink sink Monitor:monitor_FR" "Scarlett Solo (3rd Gen.) Analog Stereo:playback_FR"

# start dwm
~/.config/dwm-bar/dwm_bar.sh > .dwm-bar.log 2>&1 &
exec dwm > ~/.dwm.log
