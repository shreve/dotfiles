set PATH ./bin /home/jacob/code/bin /home/jacob/.rbenv/shims /home/jacob/.rbenv/bin $PATH
set CDPATH ./ ~/
rbenv rehash >/dev/null ^&1

alias bi "bundle install"
alias bu "bundle update"
alias bx "bundle exec"

alias c "clear"

function compress
  tar czfv $argv.tar.gz $argv
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

function mkd
  mkdir $argv
  cd $argv
end

alias search "find . -type f -name"

function search_and_destroy
  search $argv -delete;
end

function size
  du -hc $argv | tail -1
end
