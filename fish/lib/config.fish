
function edit
    if test "$argv[-2]" = "which"
        spawn terminal --command $EDITOR (which $argv[-1])
    else
        spawn terminal --command $EDITOR $argv
    end
end


# Check start time for emacs with and without my config
function emacs-profile
    /bin/time -f '%e' emacs --eval '(kill-emacs)'
    /bin/time -f '%e' emacs -Q --eval '(kill-emacs)'
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


function grep-nonascii
    grep --color='auto' -P -n "[\x80-\xFF]" $argv
end

function find-nonascii
    LC_ALL=C find . -name '*[! -~]*'
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

# Enables `sudo !!` to repeat the last command like in bash
function sudo
    if test "$argv" = "!!"
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

function tags
    pushd .git
    fd -tf -E '*.json' . ../ | xargs ctags -f tags $argv 2>/dev/null
    popd
end

# Remove all metadata from a pdf
function wipe
    exiftool -all= -overwrite_original $argv
    and qpdf --linearize "$argv" "$argv".linearized
    and mv "$argv".linearized "$argv"
end


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



# Decorate a program to append the current directory as an argument
function default-to-here
    set cmd $argv[1]

    function $cmd -V cmd --wraps $cmd
        if test (count $argv) -lt 2
            set -a argv ./
        end
        set -p argv (which $cmd)
        $argv
    end
end

default-to-here cp
default-to-here mv
