#!/bin/sh

# A dwm_bar function to show the current network connection/SSID, private IP, and public IP using NetworkManager
# Joe Standring <git@joestandring.com>
# GNU GPLv3

# Dependencies: NetworkManager, curl

dwm_networkmanager () {
    CONNAME="br0"
    if [ "$CONNAME" = "" ]; then
        CONNAME=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -c 5-)
    fi

    PRIVATE=$(nmcli connection show $CONNAME | grep 'IP4.ADDRESS\[1\]:' | awk '{print $2}')

    if [ "$IDENTIFIER" = "unicode" ]; then
        export __DWM_BAR_NETWORKMANAGER__="${SEP1}🌐 ${PRIVATE}${SEP2}"
    else
        export __DWM_BAR_NETWORKMANAGER__="${SEP1}NET ${CONNAME} ${PRIVATE} ${PUBLIC}${SEP2}"
    fi
}

dwm_networkmanager
