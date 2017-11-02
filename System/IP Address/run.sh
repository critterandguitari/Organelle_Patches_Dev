#!/bin/bash

# don't clear aux screen.  it is cleared and set with OG version 
# on first line before this script is called

IP=$(ip -o -4 addr list wlan0 | awk '{print $4}' | cut -d/ -f1)
HOST=$(ps aux | grep 'avahi.*running' | awk 'NR==1{print $13}' | sed 's/\[//' | sed 's/\]//')

oscsend localhost 4001 /oled/aux/line/1 s "$IP"
oscsend localhost 4001 /oled/aux/line/2 s "$HOST"
oscsend localhost 4001 /oled/aux/line/3 s " "
oscsend localhost 4001 /oled/aux/line/4 s " "
oscsend localhost 4001 /oled/aux/line/5 s " "

# set to aux screen, signals screen update
oscsend localhost 4001 /oled/setscreen i 1
