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

set my_paths ~/code/dotfiles/bin ~/code/vendor/bin ./bin ~/.local/bin

set EDITOR emacs
set -x GOPATH ~/code/go
set NPMPATH node_modules/.bin
set PATH  $my_paths ~/.rbenv/bin ~/.cargo/bin ~/.yarn/bin $NPMPATH $GOPATH/bin $PATH
set CDPATH ./ ~/ ~/code ~/Documents/School
set -x GPG_TTY (tty)

eval (direnv hook fish)

status --is-interactive; and source (rbenv init -|psub)

function blue
  pactl load-module module-bluetooth-discover
  echo "connect 04:FE:A1:DD:22:FD" | bluetoothctl
end

alias bi "bundle install"
alias bu "bundle update"
alias bx "bundle exec"

alias c "clear"

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

# Center a blob of text which is less than full-width
function center-text
  cat $argv > /tmp/center
  set -l screen (tput cols)
  set -l max 0
  cat /tmp/center | while read -l line
    set -l length (string length $line)
    if test $length -gt $max
      set max $length
    end
  end
  set -l pad (math "($screen - $max)/2")
  cat /tmp/center | while read -l line
    printf "%"$pad"s" " "
    echo $line
  end
end

function compress
  tar czfv $argv.tar.gz $argv
end

function confirm-kill
  if pgrep $argv >/dev/null
    read -l -P  "Kill $argv? [y/n] " cont
    switch $cont
      case y Y
        killall $argv
    end
  end
end

alias copy "xsel -i --clipboard"

function cppp
  g++ -Wall -Werror -pedantic -g $argv.cpp -p $argv
  if $status == 0
    clear
    ./$argv
  end
end

# Add the current directory to the list of arguments
function default-to-here
    set cmd $argv[1]

    eval "function $cmd
      if test (count \$argv) -lt 2
        set argv \$argv ./
      end
      for i in \$argv; echo \"\$i\"; end | xargs -d\"\n\" (which $cmd)
    end"
end

default-to-here cp
default-to-here mv

# keep downloading the file until it's 100% done
# -O maintains the file name from the URL
function download
  keep-doing curl -O -C - $argv
end

function docker-killall
  docker stop (docker ps -a -q --no-trunc) >/dev/null
end

function docker-clean
  docker-killall
  docker container prune -f
  docker image prune -f
  docker volume prune -f
end

function draw_separator --on-event fish_prompt
  set_color 333
  printf "\n%*s" (tput cols) | sed -e 's/ /\—/g'
end

# Open emacs in the background then detach
function emacs-bg
  if test $argv[1] = 'which'
    spawn emacs (which $argv[2])
  else
    spawn emacs $argv
  end
end

alias e emacs-bg

# Check start time for emacs with and without my config
function emacs-profile
    time -f '%e' emacs --eval '(kill-emacs)'
    time -f '%e' emacs -Q --eval '(kill-emacs)'
end

alias extract "tar xzfv"

function fishrc
  emacs ~/.config/fish/config.fish
  source ~/.config/fish/config.fish
end

function fish_greeting
  pretty-fortune
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
    emacs ~/code/dotfiles/hosts
end

function update-hosts
  ls ~/code/dotfiles/hosts/* | grep -v "!" | xargs cat | sudo tee /etc/hosts
end

function hw2pdf
  xelatex -halt-on-error "$argv"

  # Run again for labels/refs for projects that use them
  # xelatex -halt-on-error "$argv"

  find . -name "*aux" -o -name "*log" -o -name "*out" | xargs rm

  inotifywait "$argv" >/dev/null 2>&1

  hw2pdf $argv
end

function keep-doing
  set -l sucesses 0 33
  while not contains $status $successes
    sleep 0.5
    eval $argv
  end
end

alias ls exa
alias ls-old "exa -al --sort modified --reverse"

function low-power
  if count $argv >/dev/null
    switch $argv
      case on
        touch /tmp/low_power_mode
        backlight 20
        reset-i3blocks
      case off
        rm /tmp/low_power_mode
        backlight 70
    end
  else
    if test -e /tmp/low_power_mode
      echo "on"
    else
      echo "off"
    end
  end
end

# Force kill with a more effective search
function massacre
  ps aux | grep -i $argv[1] | awk '{print $2}' | sort -r | xargs kill -9
end

function mkd
  mkdir $argv
  cd $argv
end

function o
  nohup xdg-open $argv ^/dev/null >/dev/null &
end

alias pg "ps aux | grep"

function pgr
  set app ""
  if count $argv
    set app "--app $argv"
  end
  psql (heroku config:get DATABASE_URL $app)
end

function portsnipe
  set pid (sudo netstat -tulpn 2>/dev/null | grep $argv | sed -e 's/^.*LISTEN\s\+\([^\/]\+\).*/\1/' | head -1)
  set pname (ps $pid | tail -1 | cut -c 28-)
  echo $pid $pname
end

function pretty-fortune
  echo
  echo
  fortune | cowsay | center-text
  echo
end

function rusty
  rustc $argv.rs
  eval ./$argv
end

function reset-i3blocks
  for i in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9";
    pkill -RTMIN+$i i3blocks
  end
end

function save_path --on-event fish_prompt
  echo "$PWD" > ~/.cache/pwd
end

alias search "fd --type file --hidden --no-ignore"

function search_and_destroy
  search $argv --exec sudo rm "{}";
end

# Collect serial number and other brand information
function serial
  set brand (sudo dmidecode -t system | grep Manufacturer | awk -F': ' '{print $2}')
  set version (sudo dmidecode -t system | grep Version | awk -F': ' '{print $2}')
  set serial (sudo dmidecode -t system | grep Serial | awk -F': ' '{print $2}')
  echo "$brand $version (S/N $serial)"
end

function settings
  spawn env XDG_CURRENT_DESKTOP=GNOME gnome-control-center
end

function shrug
  echo -n "¯\\_(ツ)_/¯" | tee /dev/stderr | copy
end

function size
  if test "$argv" = ""
    du -hc -d 1 2>/dev/null | sort -hr | bat
  else
    du -h $argv
  end
end

# Start and detach a process
function spawn
  silently nohup $argv &
end

# Capture all output and send it to null
function silently
  command $argv >/dev/null 2>&1
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
  sudo apt update >/dev/null 2>&1

  echo "sudo apt list --upgradable"
  sudo apt list --upgradable

  read -l -P 'Download updates? [y/n]' cont

  switch $cont
    case y Y

      echo "sudo apt upgrade"
      sudo apt upgrade
  end

  echo "sudo apt autoremove"
  sudo apt autoremove
end

# Remove all metadata from a pdf
function wipe
    exiftool -all= -overwrite_original $argv
    and qpdf --linearize "$argv" "$argv".linearized
    and mv "$argv".linearized "$argv"
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
  bind \ce "__edit_input"
end
