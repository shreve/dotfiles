#!/bin/bash

# Remap caps lock to a left control key
xmodmap -e "remove lock = Caps_Lock"
xmodmap -e "keycode 66 = Control_L"
xmodmap -e "add control = Control_L"

xset r rate 250 60  # Set keyboard repeat rate
# xset +dpms          # Turn on Energy Star features
# xset dpms 60 60 60  # Turn off the monitor after 60 seconds
# xset s off          # Turn off the screen saver

feh --bg-scale /home/jacob/Pictures/wallpaper.jpg

# Enable flux to run in the background
fluxgui &

# Set display resolution
xrandr --dpi 200

# Start Enpass and kill the window that pops up
/opt/Enpass/bin/runenpass.sh &
sleep 0.5 ; i3-msg kill

exec gnome-settings-daemon &

exec xscreensaver &
exec /home/jacob/code/dotfiles/bin/keylight watch-screen

i3-msg reload
i3-msg restart
