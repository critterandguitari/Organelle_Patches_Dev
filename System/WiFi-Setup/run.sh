#!/bin/sh


oscsend localhost 4001 /oled/aux/clear i 1
oscsend localhost 4001 /oled/aux/line/2 s "Starting..."
#oscsend localhost 4001 /oled/aux/line/2 s "$WORK_DIR/wifi_config.py"
oscsend localhost 4001 /oled/setscreen i 1

python2 "$WORK_DIR/wifi_setup.py"

