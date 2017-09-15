#!/bin/bash

oscsend localhost 4001 /oled/aux/line/1 s " "
oscsend localhost 4001 /oled/aux/line/2 s "Installing..."
oscsend localhost 4001 /oled/aux/line/3 s "Software..."
oscsend localhost 4001 /oled/aux/line/4 s " "
oscsend localhost 4001 /oled/aux/line/5 s " "

# set to aux screen, signals screen update
oscsend localhost 4001 /oled/setscreen i 1

/root/scripts/remount-rw.sh

cd /usbdrive/System/Install-Software

# install stuff for AP mode, web stuff, avahi
echo 'installing pacman packages'
pacman -U --needed --noconfirm ./pkg/*.pkg.tar.xz

# install cherry py and pyliblo
echo 'upgrading pip'
pip2 install --upgrade --no-index --find-links=./python pip # gotta upgrade pip otherwise pyliblo doesn't install
echo 'installing cherrypy'
pip2 install --no-index --find-links=./python cherrypy
echo 'installing pyliblo'
pip2 install --no-index --find-links=./python pyliblo

echo 'configuring'

# config for avahi
cp -f ./etc/nsswitch.conf /etc/nsswitch.conf

# enable avahi
systemctl start avahi-daemon
systemctl enable avahi-daemon

oscsend localhost 4001 /oled/aux/line/2 s "Done"
oscsend localhost 4001 /oled/aux/line/3 s " "

sync

/root/scripts/remount-ro.sh

echo 'done'
