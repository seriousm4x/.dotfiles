#!/bin/sh

# A dwm_bar function to show VPN connections with OpenVPN or WireGuard (if any are active)
# Joe Standring <git@joestandring.com>
# GNU GPLv3

# Dependencies: NetworkManager, NetworkManager-openvpn (for OpenVPN connections)

dwm_vpn () {
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
        printf "%s" "$SEP1"
        if [ "$IDENTIFIER" = "unicode" ]; then
            printf "🔒 %s" "$VPN"
        else
            printf "VPN %s" "$VPN"
        fi
        printf "%s\n" "$SEP2"
    fi
}


dwm_vpn
