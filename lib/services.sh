#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[1;37m'

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
    chmod +x ~/.config/autostart/downganizer.desktop
    echo "Downganzier disabled"
}

is_array() {
  local var_name="$1"
  if ( unset "${var_name}[0]" 2>/dev/null ); then
    return 0
  else
    return 1
  fi
}

status () {
    title="$WHITE Downganizer Status"
    load="$RED Autostart not loaded$WHITE"
    status="$RED Stopped $WHITE"
    cpu=0
    mem=0

    inot=$(pgrep -f inotifywait | head -n 1)
    inotpid=0
    moni=$(pgrep -f monitor.sh | head -n 1)

    if [[ -n "$inot" ]] && [[ -n "$moni" ]]; then
        start=$(ps -p "$inot" -o stime=)
        status="$GREEN Active $WHITE(Since: $start)"
        cpu=$(ps -p $inot -o %cpu | grep -v "CPU" | cut -d ' ' -f2)
        mem=$(ps -p $inot -o %mem | grep -v "MEM" | cut -d ' ' -f2)
    fi

    file=/home/$USER/.config/autostart/downganizer.desktop
    if [[ -f $file ]]; then
        enabled=$(grep 'Autostart-enabled=true' $file)
        if [[ -n "$enabled" ]]; then
            load="Loaded (/home/$USER/.config/autostart/downganizer.desktop)"
        fi
    fi
    echo -e "$title
    Loaded: $load
    Status: $status
    CPU Usage: $cpu%
    Memory Usage: $mem%
    Press 'q' to exit"
}

dg_status() {
    status
    # watch -n 1 -t "bash -c '$(declare -f status); status'"
}

create_autostart_file () {
    echo "[Desktop Entry]
Type=Application
Name=Downganizer
Exec=$SCRIPT_DIR/downganizer start
Comment=Organize your Downloads directory
Icon=$SCRIPT_DIR/icon.png
X-GNOME-Autostart-enabled=false" > ~/.config/autostart/downganizer.desktop
    chmod +x ~/.config/autostart/downganizer.desktop
}
