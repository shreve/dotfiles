set -gx LANG en_US.UTF-8
set -gx EDITOR vim
set -gx ROKU_HOST 192.168.0.100
set -gx FZF_DEFAULT_COMMAND "fd -tf"
set -gx BAT_THEME "Monokai Extended Origin"
set -gx MAMBA_NO_BANNER 1

set -gx DOTPATH ~/priv/code/dotfiles
set -gx FISHPATH ~/.config/fish/conf.d
set -gx GOPATH ~/code/go

set -gx CDPATH \
    ./ \
    ~/ \
    ~/code/ \
    ~/priv/code/ \
    ~/code/mads-for-each/repos/

set USERPATH \
    ~/bin \
    ~/code/vendor/bin \
    ./bin

set SYSPATH \
    /usr/local/bin \
    /usr/bin \
    /usr/sbin \
    /bin \
    /usr/local/sbin \
    /sbin

set VENDORPATH \
    /opt/homebrew/bin \
    ~/.krew/bin \
    $GOPATH/bin \
    node_modules/.bin \
    /usr/bin/vendor_perl \
    /Library/TeX/texbin

set -gx PATH $USERPATH $SYSPATH $VENDORPATH

# If the platform hasn't been hard-coded, figure it out.
if ! set -q PLATFORM
    set uname (uname)
    switch $uname
        case "Darwin"
            set -gx PLATFORM "macos"
        case "Linux"
            set -gx PLATFORM "linux"
        case "*"
            set -gx PLATFORM "$uname"
    end
end
