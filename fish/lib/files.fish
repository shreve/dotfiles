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

function compress
    set -l name (echo "$argv" | sed 's/\/$//')
    tar czfv $name.tar.gz $name
end
