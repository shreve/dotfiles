#!/usr/bin/env fish

function pretty-fortune
    fortune | cowsay -f tux.cow -W (tput cols) -n | center
end
