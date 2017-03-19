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
set PATH ./bin ~/code/dotfiles/bin ~/.rbenv/bin $PATH
set CDPATH ./ ~/ ~/code ~/Documents/School

source ~/.config/fish/conf.d/omf.fish

status --is-interactive; and source (rbenv init -|psub)

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

# Force kill with a more effective search
function massacre
  ps aux | grep -i $argv[1] | awk '{print $2}' | xargs kill -9
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

alias ytmp3 "youtube-dl -x --audio-format mp3"

function __edit_input
  commandline > /tmp/input
  emacs /tmp/input
  commandline (cat /tmp/input)
end

bind \ce "__edit_input"

# Prefix the previous line with $argv
function __run_with_prefix
  commandline -i $argv
  commandline -i ' '
  commandline -i $history[1]
end

function __bind_keys
  bind \cs "__run_with_prefix sudo"
  bind \cb "__run_with_prefix bx"
end
__bind_keys
