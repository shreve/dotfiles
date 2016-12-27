# =================================================================================================
#
#                                       1337 .bashrc
#
# =================================================================================================
#
#   Table of Contents:
#   1.  Environment Configuration
#   2.  Sensible Defaults, and Enhancements
#   3.  File & Folder Management
#   4.  Searching
#   5.  Development
#   6.  Networking
#   7.  Processes
#   8.  Initializers
#   9.  Labs

#/////////////////////////////
#
#   1.  Environment Configuration
#
#////////////////////////
export EDITOR="vim"
export DOTPATH="/Users/jacob/sync/code/dotfiles"
export DOT=$DOTPATH
export CLICOLOR=1
export CDPATH="./:~/sync:~/sync/code"
export PROMPT_COMMAND='
  PS1="[\[\e[1;35m\]`pwd | sed -E "s/\/Users\/jacob/~/" | sed -E "s/.*\/(.+\/.+)/\1/"`\[\e[0m\]]: ";
  PS2="$PS1> ";
'
export PATH="/Users/jacob/sync/code/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/heroku/bin"

#/////////////////////////////
#
#   2.  Sensible Defaults, and Enhancements
#
#////////////////////////
alias ~="cd ~"
alias c="clear"
alias cp="cp -iv"
alias mv="mv -iv"
alias ls="ls -FAGh"
alias ..="cd ../"
alias ...="cd ../../"
alias so=". ~/.bash_profile"
alias tac="sed '1!G;h;\$!d'"
alias tree="tree -C"
alias trls="tree -C | less -R"
alias clock="while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done &"
cd() {
  builtin cd "$@"
  ls
  if [ -d ./.hg ]; then
    hg st
  fi
}

history() {
  LINES="-20"
  if [[ -n $1 ]]; then LINES="-$1"; echo "Showing $1 most used commands"; fi
  builtin history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head $LINES
}

mkd() {
  mkdir $@ && cd $@
}

#/////////////////////////////
#
#   3. File & Folder Management
#
#////////////////////////
alias passwd="vim /private/pwd"                                           # files edited frequently enough to warrant aliases
alias hosts="echo 'Are you really sure you want to do this?
'; sleep 5; sudo vim /private/etc/hosts"                               #   > system hosts
alias vhosts="sudo vim /private/etc/apache2/extra/httpd-vhosts.conf"    #   > apache virtual hosts
alias bashrc="vim $DOT/bashrc; so"                                         #   > this file!
alias vimrc="vim $DOT/vimrc"                                            #   > this file, but the vim version!
alias tmuxrc="vim $DOT/tmuxrc"
alias gitconfig="vim $DOT/git/config"                                    #   > global git configuration
alias finder="open -a Finder ./"                                        # open pwd in Finder
alias rm-ds="search_and_destroy .DS_Store"                              # recursively remove .DS_Store files
alias lss="du -sh * | sort -nr | head"                                  # list files in a directory with their size
alias notes="vim ./.notes"
size () { du -hc $1 | tail -1; }
alias bsize="stat -f '%z bytes'"
alias sizes="du -h -d 1 | sed -E 's/\.\///'"
zipf () { zip -r "$1".zip "$1" ; }                                      # zip a folder
tarc () { tar cvzf "$1".tar.gz "$1" ; }
tare () { tar xvf "$1" ; }
trash () {
  if [ ! -e "/tmp/trash.aif" ]; then
    ln -s /System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/dock/drag\ to\ trash.aif /tmp/trash.aif
  fi
  command mv "$@" ~/.Trash ; ( afplay /tmp/trash.aif & ) > /dev/null
}
preview () { qlmanage -p "$*" >& /dev/null; }                           # open a file in quicklook / preview
search_and_destroy() {
  sudo find . -type f -name "$1" -depth -delete;
}

#/////////////////////////////
#
#   4. Searching
#
#////////////////////////
alias update_locate="sudo /usr/libexec/locate.updatedb &"                 # update `locate`'s database
ff() { find . -name "$@" ; }                                            # find via name
ff0() { ff '*'"$@" ; }                                                  # find where name ends with search
ff1() { ff "$@"'*' ; }                                                  # find where name starts with search
spotlight() { mdfind "kMDItemDisplayName == '$@'wc" ; }                 # find via spotlight
recentfiles() {                                                         # find via ctime
  find . -ctime -$1 -type f ! -name '.*' ! -regex '.*/\..*/.*' ! -name '*.log'
}

#/////////////////////////////
#
#   5.  Development
#
#////////////////////////
alias bx="bundle exec"                                                  # bundle execute
alias bi="bundle install; bundle clean"
alias bu="bundle update"                                                #        update
alias bc="bundle clean"
alias vi="vim"                                                          # goddamn vi
alias vim="reattach-to-user-namespace vim"
alias pow="powder"
alias heorku="heroku"                                                   # goddamn heroku, keyboard acrobatics
alias tmux="tmux -2"
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias postjson="curl -k -X POST --header \"Content-Type: application/json\""

rusty() {
  rustc ${1}.rs;
  ./$1
}

cppp() {
  # Strip the extension from whatever's passed
  c++ ${1}.cpp -o ${1%%.*};
  if [ $? -eq 0 ]; then
    clear;
    ./${1%%.*}
  fi
}

pgr() {
  string=""
  if [[ ! -z "$1" ]]; then
    string="--app $1"
  fi
  psql `heroku config:get DATABASE_URL $string`
}

#/////////////////////////////
#
#   6.  Networking
#
#////////////////////////
router() { open "http://$(ip r)"; }
restart_router() {
  formstring="pws=d41d8cd98f00b204e9800998ecf8427e&totalMSec=`date +%s`"
  curl http://192.168.2.1/cgi-bin/login.exe -vsLd $formstring
  curl http://192.168.2.1/cgi-bin/restart.exe -vsLd "page=tools_gateway&logout"
}

#/////////////////////////////
#
#   8.  Initializers
#
#////////////////////////
eval "$(rbenv init -)"
# Prefer binstubs to rbenv shims
export PATH="./bin:$PATH"

# Disable XOFF on <C-S>
bind -r '\C-s'
stty -ixon

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

#         .---.
#        _\___/_
#         )\_/(
#        /     \
#       /       \
#      /         \
#     /~~~~~~~~~~~\
#    /   9. Labs   \
#   (               )
#    `-------------'

# Repeat a command until it finishes with exit code 0
keep-doing() {
  # set a default non-zero value
  export exit_code=1
  # time the operation
  #    repeat while the exit code isn't 0
  time while [[ $exit_code -ne 0 || $exit_code -ne 33 ]]
  do
    # run the passed in command
    $@
    # then grab the exit code of the last command
    export exit_code=$?
  done
}

download() {
  # keep downloading the file until it's 100% done
  # -O maintains the file name from the URL
  keep-doing curl -O -C - $@
}

spoof-mac() {
  local address=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
  echo "Trying to change address to $address"
  sudo ifconfig en0 ether $address
  ifconfig en0 | grep ether
}

alias ytmp3="youtube-dl -x --audio-format mp3"

#                  |
#                  |
#                 ,|.
#                ,\|/.
#              ,' .V. `.
#             / .     . \
#            /_`       '_\
#           ,' .:     ;, `.
#           |@)|  . .  |(@|
#      ,-._ `._';  .  :`_,' _,-.
#     '--  `-\ /,-===-.\ /-'  --`
#    (----  _|  ||___||  |_  ----)
#     `._,-'  \  `-.-'  /  `-._,'
#              `-.___,-'

                 fish