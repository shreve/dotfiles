# Aliases, but also really tiny functions.

alias :q "exit"
alias bi "bundle install"
alias boop "ping"  # https://twitter.com/jessica_schalz/status/1292973216634372097
alias bu "bundle update"
alias bx "bundle exec"
alias c "echo Use ctrl-l"
alias clear "echo Use ctrl-l"
alias e "edit"
alias extract "tar xzfv"
alias groot "cd (git root)"
alias hosts "sudo $EDITOR /etc/hosts"
alias hw2pdf "tex2pdf"
alias k "kubectl"
alias ls "exa"
alias lsa "ls -al"
alias lsb "ls -al --sort size --reverse"
alias lso "ls -al --sort modified --reverse"
alias lss "ls -al --sort size"
alias pg "ps aux | grep"
alias search "fd --type file --hidden --no-ignore"
alias vi "nvim"
alias vim "nvim"
alias ytx "youtube-dl -x --audio-format best"

function http
    set orig (which http)
    $orig --session (pwd | xargs basename) $argv
end


function mkd
    mkdir -p $argv
    cd $argv
end

function touchx
    touch $argv
    echo "#!/usr/bin/env bash" > $argv
    chmod +x $argv
end

function o
    for arg in $argv
        nohup open $arg ^/dev/null >/dev/null &
    end
end

function search_and_destroy
    search $argv --exec rm "{}";
end

function shrug
    echo -n "¯\\_(ツ)_/¯" | tee /dev/stderr | copy
end
