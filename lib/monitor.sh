#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

source "$SCRIPT_DIR/downganize.sh"

inotifywait -m ~/Downloads -e create -e moved_to 2>/dev/null|
while read -r directory event file; do
    if [ -d "$HOME/Downloads/$file" ]; then
        continue
    fi
    siz=$(stat -c %s "$HOME/Downloads/$file")
    if [ -z "$siz"] || [ "$siz" -eq 0 ]; then
        sleep 0.5
        siz=$(stat -c %s "$HOME/Downloads/$file")
        if [ -z "$siz" ] || [ "$siz" -eq 0 ]; then
            continue
        fi
    fi
    sort_file "$HOME/Downloads/$file"
done 2>/dev/null