#!/bin/bash

xrandr --dpi 200

xset r rate 250 60

# Remap caps lock to a left control key
xmodmap -e "remove lock = Caps_Lock"
xmodmap -e "keycode 66 = Control_L"
xmodmap -e "add control = Control_L"

gnome-settings-daemon &

/opt/Enpass/bin/runenpass.sh &
sleep 0.5 ; i3-msg kill

feh --bg-scale /home/jacob/Pictures/wallpaper.jpg

i3-msg reload
i3-msg restart
