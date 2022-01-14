#!/bin/bash

SEP="|"

bar_vpn () {
    nm_vpn=$(nmcli -a | grep 'VPN connection' | sed -e 's/\( VPN connection\)*$//g')
    wg_vpn=$(nmcli connection | grep 'wireguard' | sed 's/\s.*$//')
    VPN="" 
    if [ -n "$nm_vpn" ]; then
        VPN=$nm_vpn
    fi
    if [ -n "$wg_vpn" ] && [ -n "$VPN" ]; then
        VPN="${VPN} $wg_vpn"
    elif [ -n "$wg_vpn" ] && [ -z "$VPN" ]; then
        VPN=$wg_vpn
    fi
    if [ "$VPN" != "" ]; then
        printf " %s" "$VPN $SEP "
    fi
}

bar_mem () {
    printf " $(free -h | grep Mem | awk '{print $3}') $SEP "
}

bar_cpu () {
    printf " $(top -bn1 | grep Cpu | awk '{print $2}')%% $SEP "
}

bar_vol () {
    VOL=$(pamixer --get-volume)
    MUTED=$(pamixer --get-mute)
    if [ "$MUTED" = "true" ] || [ "$VOL" -eq 0 ]; then
        printf " $SEP "
    elif [ "$VOL" -gt 0 ] && [ "$VOL" -le 50 ]; then
        printf " $VOL%% $SEP "
    else
        printf " $VOL%% $SEP "
    fi
}

bar_date () {
    printf " %s" "$(date "+%a, %d.%m.%Y, %T") $SEP"
}

parallelize () {
    while true; do
        yay -Sy > /dev/null
        updates=$(yay -Qu | wc -l)
        if [ "$updates" -eq 0 ]; then
            echo " Updated $SEP " >| /tmp/dwm-bar-updates
        else
            echo "  $updates Updates $SEP " >| /tmp/dwm-bar-updates
        fi
        sleep 30m
    done
}
parallelize &

while true; do
    xsetroot -name "$(cat /tmp/dwm-bar-updates)$(bar_vpn)$(bar_mem)$(bar_cpu)$(bar_vol)$(bar_date)"
    sleep 1
done
