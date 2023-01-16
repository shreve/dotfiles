function spawn --description 'Start and detach a process'
    $argv &
    disown
end

function respawn --description 'Kill and replace a process'
    massacre $argv
    spawn $argv
end

function silently --description 'Capture all output and send it to null'
    eval $argv >/dev/null 2>&1
end

function massacre --description 'Force kill with a more effective search'
    ps aux | grep -i $argv[1] | grep -v grep | awk '{print $2}' | sort -r | xargs kill -9
end


function psearch
    set -l query "COMMAND\|$argv"
    ps aux | grep --color=always $query | grep -v "grep"
end

function portsnipe
    set pid (sudo netstat -tulpn 2>/dev/null | grep $argv | sed -e 's/^.*LISTEN\s\+\([^\/]\+\).*/\1/' | head -1)
    set pname (ps $pid | tail -1 | cut -c 28-)
    echo $pid $pname
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
