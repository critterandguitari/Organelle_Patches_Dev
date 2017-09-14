#!/bin/bash

oscsend localhost 4001 /oled/aux/line/1 s " "
oscsend localhost 4001 /oled/aux/line/2 s "Installing WiFi"
oscsend localhost 4001 /oled/aux/line/3 s "Software..."
oscsend localhost 4001 /oled/aux/line/4 s " "
oscsend localhost 4001 /oled/aux/line/5 s " "

# set to aux screen, signals screen update
oscsend localhost 4001 /oled/setscreen i 1

cd /usbdrive/System/Install-WiFi-AP

# install stuff for AP mode, web stuff, avahi
pacman -U --needed --noconfirm ./pkg/*.pkg.tar.xz

# install cherry py
pip2 install --no-index --find-links=./cherrypy cherrypy

# install createap
cp ./scripts/create_ap /root/scripts/

# config for avahi
cp ./etc/nsswitch.conf /etc/nsswitch.conf

# enable avahi
systemctl start avahi-daemon
systemctl enable avahi-daemon

oscsend localhost 4001 /oled/aux/line/2 s "Done"
oscsend localhost 4001 /oled/aux/line/3 s " "


