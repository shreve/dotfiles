function docker-killall
    docker stop (docker ps -a -q --no-trunc) >/dev/null
end

function docker-clean
    docker-killall
    docker container prune -f
    docker image prune -f
    docker volume prune -f
end
