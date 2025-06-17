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
    echo ;
}

dg_enable () {
    echo ;
}

dg_disable () {
    echo ;
}

dg_status () {
    echo ;
}