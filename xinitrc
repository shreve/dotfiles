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
feh --bg-scale /home/jacob/Pictures/wallpaper.jpg

# Enable flux to run in the background
fluxgui &

# Start Enpass and kill the window that pops up
/opt/Enpass/bin/runenpass.sh &
sleep 0.5 ; i3-msg kill >/dev/null

exec gnome-settings-daemon >/dev/null 2>&1 &

exec xscreensaver -no-splash >/dev/null 2>&1 &
exec /home/jacob/code/dotfiles/bin/keylight watch-screen >/dev/null 2>&1 &
exec brightside &

i3-msg restart
