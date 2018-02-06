#!/usr/bin/env bash

set -e

P=$(pwd -P)

link() {
  if [ -h $2 ]; then
    echo "$2 exists. Removing."
    sudo rm $2;
  fi
  sudo ln -s $P/$1 $2
}

link bin ~/bin

mkdir -p ~/.config/dunst
link dunstrc ~/.config/dunst/dunstrc

link emacs.el ~/.emacs
link emacs.d ~/.emacs.d

link config.fish ~/.config/fish/config.fish

link gemrc ~/.gemrc

link git/config ~/.gitconfig
link git/ignore ~/.gitignore
link git/message ~/.gitmessage
link git/template ~/.gittemplate

link hg/ignore ~/.hgignore
link hg/rc ~/.hgrc

link irbrc.rb ~/.irbrc

mkdir -p ~/.config/i3
mkdir -p ~/.config/i3blocks
link i3/conf ~/.config/i3/config
link i3/blocks.conf ~/.config/i3blocks/config
link i3/status ~/.i3status.conf

link nginx-dev.conf /etc/nginx/sites-enabled/dev

link psqlrc.sql ~/.psqlrc

link xinitrc ~/.xinitrc

link bin/keylight /etc/pm/sleep.d/10keylight
