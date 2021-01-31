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
    sudo ln -s $P/$1 $2
  fi
}

link bin ~/bin

link dunstrc ~/.config/dunst/dunstrc

link vim ~/.config/nvim

link config.fish ~/.config/fish/config.fish

link gemrc ~/.gemrc

link git/config ~/.gitconfig
link git/ignore ~/.gitignore
link git/message ~/.gitmessage
link git/template ~/.gittemplate

link irbrc.rb ~/.irbrc

link i3/conf ~/.config/i3/config
link i3/blocks.conf ~/.config/i3blocks/config
link i3/status ~/.i3status.conf

link psqlrc.sql ~/.psqlrc

link xinitrc ~/.xinitrc
link xmodmap ~/.Xmodmap

link konsole ~/.local/share/konsole
link konsole/konsolerc ~/.config/konsolerc

# link bin/keylight /etc/pm/sleep.d/10keylight

link /home/jacob/.local/share/Trash/files ~/.trash


link services/syncthing.service /etc/systemd/system/syncthing.service

