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
set -x GOPATH ~/code/go
set NPMPATH node_modules/.bin
set PATH ~/code/dotfiles/bin ./bin ~/.rbenv/bin ~/.cargo/bin ~/.yarn/bin $NPMPATH $GOPATH/bin $PATH
set CDPATH ./ ~/ ~/code ~/Documents/School
set -x GPG_TTY (tty)

eval (direnv hook fish)

status --is-interactive; and source (rbenv init -|psub)

alias bi "bundle install"
alias bu "bundle update"
alias bx "bundle exec"

alias c "clear"

function compress
  tar czfv $argv.tar.gz $argv
end

alias copy "xsel -i --clipboard"

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

function docker-clean
  docker stop (docker ps -a -q --no-trunc)
  docker rm (docker ps -a -q --no-trunc)
  docker rmi -f (docker images -a -q --no-trunc)
  docker volume rm (docker volume ls -qf dangling=true)
end

function draw_separator --on-event fish_prompt
  set_color 333
  printf "\n%*s" (tput cols) | sed -e 's/ /\—/g'
end

function emacs-bg
  if test $argv[1] = 'which'
    emacs (which $argv[2]) &
  else
    emacs $argv &
  end
end

alias e emacs-bg

alias extract "tar xzfv"

function fishrc
  emacs ~/.config/fish/config.fish
  source ~/.config/fish/config.fish
end

function fish_mode_prompt --description 'Displays the current vi mode'
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    switch $fish_bind_mode
      case default
        set_color --bold yellow
        echo 'N'
      case insert
        set_color --bold green
        echo 'I'
      case replace-one
        set_color --bold green
        echo 'R'
      case visual
        set_color --bold magenta
        echo 'V'
    end
    set_color normal
    echo -n ' '
  end
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

function hosts
  sudo emacs /etc/hosts &
end

function keep-doing
  set -l sucesses 0 33
  while not contains $status $successes
    sleep 0.5
    eval $argv
  end
end

alias ls exa

# Force kill with a more effective search
function massacre
  ps aux | grep -i $argv[1] | awk '{print $2}' | xargs kill -9
end

function mkd
  mkdir $argv
  cd $argv
end

function o
  xdg-open $argv 2>&1 >/dev/null &
end

function pgr
  set app ""
  if count $argv
    set app "--app $argv"
  end
  psql (heroku config:get DATABASE_URL $app)
end

function portsnipe
  set pid (netstat -tulpn 2>/dev/null | grep $argv | sed -e 's/^.*LISTEN\s\+\([^\/]\+\).*/\1/')
  set pname (ps $pid | tail -1 | cut -c 28-)
  echo $pid $pname
end

function rusty
  rustc $argv.rs
  ./$argv
end

function save_path --on-event fish_prompt
  echo $PWD > ~/.cache/pwd
end

alias search "find . -type f -name"

function search_and_destroy
  search $argv -delete;
end

function settings
  spawn env XDG_CURRENT_DESKTOP=GNOME gnome-control-center
end

function shrug
  echo -n "¯\\_(ツ)_/¯" | tee /dev/stderr | copy
end

function size
  du -hc $argv | tail -1
end

function spawn
  nohup $argv >/dev/null &
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
  fd -HI -tf "\.(rb|js)" | etags - &
end

# Find and replace in card titles across all boards
function trello_title_gsub
  return
  set -l board_ids (trello board list --output tsv | awk '{print $1}')
  for id in $board_ids
    set -l cards (http GET "https://api.trello.com/1/boards/$id/cards?fields=id,name&key=$TRELLO_DEVELOPER_PUBLIC_KEY&token=$TRELLO_MEMBER_TOKEN" --body)

    echo cards | \                          # Get the list of all card ids on this board
      sed -e 's/},/},\n/g' | \              # Split the JSON onto multiple lines
      grep $argv[1] | \                     # Look for relevant cards
      sed -e 's/$argv[1]/$argv[2]/g' | \    # Make the text replacement
      sed -e 's/\\\"/\\\\\'/g' | \          # Change escaped double quotes to escaped single quotes
      awk -F '"' '{print $4 ";;;" $8}' | \  # Extract the card id and name text
      sed -e 's/\\\\\'/\\\"/g' | \          # Revert the quote swap done above
      awk -F ';;;' '{print "http PUT \"https://api.trello.com/1/cards" $1 "?key=$TRELLO_DEVELOPER_PUBLIC_KEY&token=$TRELLO_MEMBER_TOKEN&name=" $2 "\"" }' | \
      fish
  end
end

function upgrade
  echo "sudo apt update"
  sudo apt update 2>&1 > /dev/null

  echo "sudo apt list --upgradable"
  sudo apt list --upgradable

  read -l -p __prompt cont

  switch $cont
    case y Y

      echo "sudo apt upgrade"
      sudo apt upgrade
  end

  echo "sudo apt autoremove"
  sudo apt autoremove
end

function __prompt
  echo 'Download updates? [y/n] '
end

alias ytmp3 "youtube-dl -x --audio-format mp3"

function __edit_input
  commandline > /tmp/input
  emacs /tmp/input
  commandline (cat /tmp/input)
end

# Prefix the previous line with $argv
function __run_with_prefix
  commandline -i $argv
  commandline -i ' '
  commandline -i $history[1]
end

function fish_user_key_bindings
  # fzf_key_bindings
  bind \cs "__run_with_prefix sudo"
  bind \cb "__run_with_prefix bx"
  bind \ce "__edit_input"
end
