#!/bin/bash

# Remap caps lock to a left control key
xmodmap -e "clear lock"
xmodmap -e "keycode 66 = Control_L"
xmodmap -e "add control = Control_L"

# Set keyboard repeat rate
xset r rate 250 60

# Set display resolution
xrandr --dpi 200

# Set wallpaper
/home/jacob/.fehbg &

# Enable flux to run in the background
fluxgui &

# Start Enpass
/home/jacob/bin/enpass

exec gnome-settings-daemon >/dev/null 2>&1 &

exec xscreensaver -no-splash >/dev/null 2>&1 &
exec /home/jacob/bin/keylight watch-screen >/dev/null 2>&1 &
exec brightside &

i3-msg restart
