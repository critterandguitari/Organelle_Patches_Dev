#!/bin/bash

IP=$(ip -o -4 addr list wlan0 | awk '{print $4}' | cut -d/ -f1)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

oscsend localhost 4001 /oled/aux/clear i 1

oscsend localhost 4001 /oled/aux/line/1 s "Started Web Server."
oscsend localhost 4001 /oled/aux/line/2 s "Vist here:"
oscsend localhost 4001 /oled/aux/line/3 s "$IP/files"
oscsend localhost 4001 /oled/aux/line/4 s "with your browser."
oscsend localhost 4001 /oled/aux/line/5 s " "

# set to aux screen, signals screen update
oscsend localhost 4001 /oled/setscreen i 1


killall python2
cd "/root/web/server"
python2 server.py
