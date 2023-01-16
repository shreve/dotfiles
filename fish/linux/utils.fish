
# Keep the screen on
function caffeine
    if test "$argv" = "off"
        xset +dpms
        xset s 60 60
    else
        xset -dpms
        xset s 0 0
    end
end

function reset-i3blocks
    for i in "0" "1" "2" "3" "4" "5" "6" "7" "8" "9";
        pkill -RTMIN+$i i3blocks
    end
end
