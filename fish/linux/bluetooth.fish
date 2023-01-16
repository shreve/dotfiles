function blue
    pactl load-module module-bluetooth-discover
    echo "connect 04:FE:A1:DD:22:FD" | bluetoothctl
end
