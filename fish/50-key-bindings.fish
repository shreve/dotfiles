# Get a recent command, either the one currently typed, or the previous
function current_or_previous_command
    set current (commandline)
    if test $current = ""
        set current $history[1]
    end
    echo "$current"
end

# Edit the current command with vim
function edit_previous_input
    # Save the command into a temporary file.
    set buf (mktemp)
    current_or_previous_command > "$buf"

    # Edit the temporary file, but change the name to one we expect.
    set confirm /tmp/fish-commandline
    vim -c 'startinsert!' -c "file $confirm" "$buf"

    # If the file was written, we've confirmed we want to run it.
    if test -s $confirm
        commandline -r (cat $confirm)
        rm $confirm
        commandline -f repaint execute
    end
end

# Prefix the previous line with $argv
function rerun_with_prefix
    commandline -r "$argv "(current_or_previous_command)
    commandline -f repaint execute
end

function clear_and_reset
    # show cursor in case it was hidden
    echo -e "\e[?25h"

    # Use the terminfo db to figure out how to clear the screen
    /usr/bin/clear
end

function bind_all_modes
    for mode in (bind --list-modes)
        bind -M $mode $argv
    end
end

function fish_user_key_bindings
    fish_vi_key_bindings

    bind_all_modes \r repaint execute
    bind_all_modes \cs 'rerun_with_prefix sudo'
    bind_all_modes \ce edit_previous_input

    bind -e --preset \cl
    bind -e --preset -M visual \cl
    bind -e --preset -M insert \cl
    bind \cl clear_and_reset
end
