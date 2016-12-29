#!/usr/bin/env bash

set -e

P=$(pwd -P)

link() {
  if [ -h $2 ]; then
    echo "$2 exists. Removing."
    rm $2;
  fi
  ln -s $P/$1 $2
}

link emacs ~/.emacs
link emacs.d ~/.emacs.d

link config.fish ~/.config/fish/config.fish

link gemrc ~/.gemrc

link git/config ~/.gitconfig
link git/ignore ~/.gitignore
link git/message ~/.gitmessage
link git/template ~/.gittemplate

link hg/ignore ~/.hgignore
link hg/rc ~/.hgrc

link irbrc ~/.irbrc

link psqlrc ~/.psqlrc
