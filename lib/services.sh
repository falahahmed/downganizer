#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

dg_start () {
    $SCRIPT_DIR/lib/monitor.sh & disown
    echo "Watches established"
    echo "Monitoring downloads"
    sleep 0.2
}

dg_stop () {
    monitors=$(pgrep -f "$SCRIPT_DIR/lib/monitor.sh")
    notifies=$(pgrep -f inotifywait)
    count=$(pgrep -c -f "$SCRIPT_DIR/lib/monitor.sh")
    if [ "$count" -eq 0 ]; then
        echo "Downganizer is not running."
        return 0
    fi
    for monitor in $monitors; do
        kill -USR1 $monitor
    done
    for notify in $notifies; do
        kill -USR1 $notify
    done
    echo "All running monitors have been stopped."
}

dg_restart () {
    dg_stop
    sleep 0.2
    dg_start
}

dg_enable () {
    if [ ! -d ~/.config/autostart ]; then
        mkdir -p ~/.config/autostart
    fi
    if [[ ! -f ~/.config/autostart/downganizer.desktop ]]; then
        create_autostart_file
    fi
    enabled=$(grep 'Autostart-enabled=true' ~/.config/autostart/downganizer.desktop)
    if [[ -n "$enabled" ]]; then
        echo "Downganizer is already enabled."
        return 0
    fi
    sed -i 's/false/true/' ~/.config/autostart/downganizer.desktop
    echo "Downganizer enabled. Reboot the system to apply changes."
}

dg_disable () {
    if [[ ! -f ~/.config/autostart/downganizer.desktop ]]; then
        echo "Downganzer is not enabled."
        return 0
    fi
    disabled=$(grep 'Autostart-enabled=false' ~/.config/autostart/downganizer.desktop)
    if [ -n "$disabled" ]; then
        echo "Downganizer is not enabled"
        return 0
    fi
    sed -i 's/true/false/' ~/.config/autostart/downganizer.desktop
    echo "Downganzier disabled"
}

MAIN_PID=0
SUB_PID=0

status () {
    date
    echo "Hello "
    var=$(pgrep -f "$SCRIPT_DIR/lib/monitor.sh")
    echo "var: $var"
}

dg_status() {
    watch -n 1 -t "bash -c '$(declare -f status); status'"
}

create_autostart_file () {
    echo "[Desktop Entry]
Type=Application
Name=Downganizer
Exec=$SCRIPT_DIR/downganizer.sh start
Comment=Organize your Downloads directory
Icon=$SCRIPT_DIR/icon.png
X-GNOME-Autostart-enabled=false" > ~/.config/autostart/downganizer.desktop
}
