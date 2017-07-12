#!/bin/bash
killall wpa_supplicant
killall dhcpcd
ip link set wlan0 up
#iw dev wlan0 set power_save off
wpa_supplicant -B -D nl80211,wext -i wlan0 -c <(wpa_passphrase “NETGEAR88” “wateryapple312”) 
dhcpcd 
