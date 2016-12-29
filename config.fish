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

set EDITOR emacs
set PATH ./bin /home/jacob/code/bin /home/jacob/.rbenv/shims /home/jacob/.rbenv/bin $PATH
set CDPATH ./ ~/ ~/code

rbenv rehash >/dev/null ^&1

alias bc "bundle clean"
alias bi "bundle install"
alias bu "bundle update"
alias bx "bundle exec"

alias c "clear"

function compress
  tar czfv $argv.tar.gz $argv
end

function cppp
  g++ -Wall -Werror -pedantic -g $argv.cpp -p $argv
  if $status == 0
    clear
    ./$argv
  end
end

# keep downloading the file until it's 100% done
# -O maintains the file name from the URL
function download
  keep-doing curl -O -C - $argv
end

function emacs-bg
  emacs $argv &
end

alias e emacs-bg

alias extract "tar xzfv"

function fishrc
  emacs ~/.config/fish/config.fish
  source ~/.config/fish/config.fish
end

# Print a list of the most commonly used commands in history, grouped by the
# first 2 terms, rather than first 1.
# Accepts count, defaults to 10
function hist
  history \
  | awk '{a[$1 " " $2]++}END{for(i in a){print a[i] "\t" i}}' \
  | sort -rn \
  | head -$argv
end

alias hosts "sudo emacs /etc/hosts &"

function keep-doing
  set -l sucesses 0 33
  while not contains $status $successes
    sleep 0.5
    eval $argv
  end
end

function mkd
  mkdir $argv
  cd $argv
end

function pgr
  set app ""
  if count $argv
    set app "--app $argv"
  end
  psql (heroku config:get DATABASE_URL $app)
end

alias portsnipe "netstat -tulpn | grep $argv | sed -e 's/^.*LISTEN\s\+\([^\/]\+\).*/\1/'"

function rusty
  rustc $argv.rs
  ./$argv
end

alias search "find . -type f -name"

function search_and_destroy
  search $argv -delete;
end

function size
  du -hc $argv | tail -1
end

# Temporarily change your MAC address, restart to reset
function spoof-mac
  wifi off
  set address (openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
  sudo ifconfig wlp4s0 hw ether $address
  wifi on
end

alias ytmp3 "youtube-dl -x --audio-format mp3"
