function source_all
    for file in $argv
        source $file
    end
end

function reload
    source_all $FISHPATH/*.fish
    echo "Reloaded $FISHPATH/"
end

function fishrc
    edit $FISHPATH
    reload
end

function fish_greeting
    pretty-fortune

    if test $fish_private_mode
        echo -e (set_color purple) "\n[Private Mode]\n"
    end
end
