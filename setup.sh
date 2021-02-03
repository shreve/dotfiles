#!/usr/bin/env bash

set -e

P=$(pwd -P)

link() {
  if [ -h $2 ]; then
    echo "$2 exists. Relinking."
    sudo rm $2;
  else
    echo "Linking $2."
  fi

  if [ ! -d $(dirname $2) ]; then
    echo "Making directory $(dirname $2)"
    mkdir -p $(dirname $2)
  fi

  if [[ $1 == /* ]]; then
    ln -s $1 $2
  else
    ln -s $P/$1 $2
  fi
}

link bin ~/bin

link irbrc.rb   ~/.irbrc
link gemrc      ~/.gemrc
link psqlrc.sql ~/.psqlrc
link sqlite.sql ~/.sqliterc
link xinitrc    ~/.xinitrc
link xmodmap    ~/.Xmodmap

link vim               ~/.config/nvim
link config.fish       ~/.config/fish/config.fish
link dunstrc           ~/.config/dunst/dunstrc
link ranger.conf       ~/.config/ranger/rc.conf
link konsole/konsolerc ~/.config/konsolerc
link i3/conf           ~/.config/i3/config
link i3/blocks.conf    ~/.config/i3blocks/config

link git/config   ~/.gitconfig
link git/ignore   ~/.gitignore
link git/message  ~/.gitmessage
link git/template ~/.gittemplate

link konsole/ ~/.local/share/konsole

# link bin/keylight /etc/pm/sleep.d/10keylight

# link services/syncthing.service /etc/systemd/system/syncthing.service

if which yay >/dev/null 2>&1; then
  echo "Installing arch packages."
  cat arch-packages.txt | xargs yay -Sy --noconfirm --needed
fi
