#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

source "$SCRIPT_DIR/lib/downganize.sh"

inotifywait -m ~/Downloads -e create -e moved_to |
while read -r directory event file; do
    if [ -d "$HOME/Downloads/$file" ]; then
        echo "Hello"
        continue
    fi
    echo "file from moni: $file"
    sort_file "$HOME/Downloads/$file"
done