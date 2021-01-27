#!/bin/bash

# Load xmodmap settings
xmodmap ~/.Xmodmap

# Set keyboard repeat rate
xset r rate 250 60

# Turn off screen after 2 minutes of inactivity
xset s 180 180
xset +dpms
xset dpms 180 180 180

# Set mouse speed
xinput --set-prop 11 'libinput Accel Speed' 0.5

# Natural scrolling
synclient VertScrollDelta=-114
synclient HorizScrollDelta=-114
synclient HorizTwoFingerScroll=1

# Set display resolution
xrandr --dpi 100

# Set wallpaper
/home/jacob/.fehbg &

# Start XSS-lock to lock the screen when it turns off
/home/jacob/bin/lock watch

# Start kde connect
kdeconnect-indicator &

# Start dpmswatch to turn the keylights off/on with screen
/home/jacob/bin/keylight watch-screen

# exec dropbox start
# i3-msg restart

exec mw daemon &

exec dunst &

exec tdm --xstart
