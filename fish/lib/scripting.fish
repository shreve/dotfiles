function warn --description "echo to stderr"
    echo "$argv" 1>&2
end

function fail --description "warn then return a non-zero"
    warn "$argv"
    return 1
end

function abort --description "warn then exit"
    warn "$argv"
    exit 1
end

function nth
    awk "{print \$$argv}"
end

function strip-ext
    rev | cut -d'.' -f2- | rev
end

function strip-white
    sed 's/^ \+//' | sed 's/ \+$//'
end

function strip-first
    awk '{$1=""; print $0}' | strip-white
end

function center \
    --description "Center the content of stdin within the terminal"

    set lines
    while read line
        set -a lines $line
    end
    set input (text-width $lines)
    set width (tput cols)
    set pad (math "floor(($width - $input)/2)")
    for line in $lines
        printf "%*s%s\n" $pad " " $line
    end
end

function text-width \
    --description "Get the length of the longest line in the input"

    set max 0
    for line in $argv
        set len (string length "$line")
        if test $len -gt $max
            set max $len
        end
    end
    echo $max
end
