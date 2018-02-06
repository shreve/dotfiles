My Bin
======

A small collection of scripts that live in my bin folder

* Battery Alert - publish a warning notification if the battery is low. This is
  triggered by a cron job
* Disp - simple wrapper for xrandr to configure external displays
* Keylight - control the keyboard backlight for lenovo laptops
* Railss - a rails server management tool
* Spec - measure the total time running rspec (to help complain about having to
  use rspec)
* Wifi - simple wrapper for nmcli to control wifi connections

### Current Window

Get attributes about the currently active i3 window using `i3-msg`. The input determines what attribute you'd like. No input defaults to `id`. `all` returns the whole window blob. All output is JSON.

![current_window demo](https://raw.githubusercontent.com/shreve/dotfiles/master/bin/_demos/current_window.gif)


September 2016, I switched from OS X to Ubuntu. These scripts are now all only
tested on Ubuntu 16.04.
