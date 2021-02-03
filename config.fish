#                              Fish Shell Config
#
#                                      |
#                                      |
#                                     ,|.
#                                    ,\|/.
#                                  ,' .V. `.
#                                 / .     . \
#                                /_`       '_\
#                               ,' .:     ;, `.
#                               |@)|  . .  |(@|
#                          ,-._ `._';  .  :`_,' _,-.
#                         '--  `-\ /,-===-.\ /-'  --`
#                        (----  _|  ||___||  |_  ----)
#                         `._,-'  \  `-.-'  /  `-._,'
#                                  `-.___,-'
#

cd (cat ~/.cache/pwd)

set -x LANG en_US.UTF-8

set -x EDITOR vim
set -x PAGER less

set -x GOPATH ~/code/go

set sys_paths /usr/local/bin /usr/bin /bin /usr/local/sbin
set my_paths ~/bin ~/code/vendor/bin ./bin
set vendor_paths ~/.cargo/bin $GOPATH/bin node_modules/.bin /usr/bin/vendor_perl
set PATH $sys_paths $my_paths $vendor_paths

set CDPATH ./ ~/ ~/code/ ~/Documents/School/
set -x GPG_TTY (tty)
set -U -x fish_emoji_width 2

set -x ROKU_HOST 192.168.0.100

eval (direnv hook fish)

# Initialize rbenv/ruby
set PATH $PATH ~/.rbenv/bin
status --is-interactive; and source (rbenv init -|psub)

set -x FZF_DEFAULT_COMMAND "fd"

cat ~/code/dotfiles/fish/* | source

alias :q exit

function blue
    pactl load-module module-bluetooth-discover
    echo "connect 04:FE:A1:DD:22:FD" | bluetoothctl
end

# https://twitter.com/jessica_schalz/status/1292973216634372097
alias boop ping

alias bi "bundle install"
alias bu "bundle update"
alias bx "bundle exec"

alias c "echo Use ctrl-l"
alias clear "echo Use ctrl-l"

# Keep the screen on
function caffeine
    if test "$argv" = "off"
        xset +dpms
        xset s 60 60
    else
        xset -dpms
        xset s 0 0
    end
end

function compress
    set -l name (echo "$argv" | sed 's/\/$//')
    tar czfv $name.tar.gz $name
end

alias copy "xclip -in -selection clipboard"

function docker-killall
    docker stop (docker ps -a -q --no-trunc) >/dev/null
end

function docker-clean
    docker-killall
    docker container prune -f
    docker image prune -f
    docker volume prune -f
end

function edit
    if test "$argv[-2]" = "which"
        spawn terminal --command $EDITOR (which $argv[-1])
    else
        spawn terminal --command $EDITOR $argv
    end
end

alias e edit

# Check start time for emacs with and without my config
function emacs-profile
    /bin/time -f '%e' emacs --eval '(kill-emacs)'
    /bin/time -f '%e' emacs -Q --eval '(kill-emacs)'
end

alias extract "tar xzfv"

alias fishrc "edit ~/.config/fish/config.fish; reload"

alias reload "source ~/.config/fish/config.fish"

# Print a list of the most commonly used commands in history, grouped by the
# first 2 terms, rather than first 1.
# Accepts count, defaults to 10
function hist
    history \
    | awk '{a[$1 " " $2]++}END{for(i in a){print a[i] "\t" i}}' \
    | sort -rn \
    | head -$argv
end

alias hosts "sudo $EDITOR /etc/hosts"

function grep-nonascii
    grep --color='auto' -P -n "[\x80-\xFF]" $argv
end

function tex2pdf
    function __render_pdf
        set -l ts (date '+%b %-d %r')
        echo -e "\n\n===> Compiling $argv at $ts <==="
        tectonic "$argv"
    end

    __render_pdf "$argv"

    inotifywait --monitor --event modify . | while read event
        echo "$event"
        if test "$event" = "./ MODIFY $argv"
            __render_pdf "$argv"
        end
    end
end

alias hw2pdf tex2pdf

alias ls exa
alias lsa "ls -al"
alias lso "ls -al --sort modified --reverse"
alias lsb "ls -al --sort size --reverse"
alias lss "ls -al --sort size"

alias make "make -j"

function mkd
    mkdir -p $argv
    cd $argv
end

function o
    for arg in $argv
        nohup xdg-open $arg ^/dev/null >/dev/null &
    end
end

function reset-i3blocks
    for i in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9";
        pkill -RTMIN+$i i3blocks
    end
end

alias search "fd --type file --hidden --no-ignore"

function search_and_destroy
    search $argv --exec sudo rm "{}";
end

function shrug
    echo -n "¯\\_(ツ)_/¯" | tee /dev/stderr | copy
end

function size
    if test "$argv" = ""
        du -hc -d 1 2>/dev/null | sort -hr
    else
        du -h -d0 $argv
    end
end

function bytesize
    du --bytes $argv | nth 1 | numfmt --to=iec --format="%0.3f"
end

# Temporarily change your MAC address, restart to reset
function spoof-mac
    wifi off
    set address (openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    sudo ifconfig wlp4s0 hw ether $address
    wifi on
end

# Enables `sudo !!` to repeat the last command like in bash
function sudo
    if test "$argv" = "!!"
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

function tags
    fd -tf | ctags - &
end

# Remove all metadata from a pdf
function wipe
    exiftool -all= -overwrite_original $argv
    and qpdf --linearize "$argv" "$argv".linearized
    and mv "$argv".linearized "$argv"
end

alias ytx "youtube-dl -x --audio-format best"

function ytxp
  while true
    read -P (set_color red)"YouTube URL"(set_color white)">  " url
    echo "Downloading $url"
    ytx $url
  end
end

function real_deep_clean
    yay -Scc --noconfirm
    docker-clean
    sudo rm /var/lib/systemd/coredump/*
end
