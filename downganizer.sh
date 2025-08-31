#!/bin/bash
# Parse arguments using getopt (GNU version)

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

PROD=false

LIB_DIR="/usr/share/downganizer/lib"

if [[ "$PROD" = false ]]; then
    LIB_DIR="$SCRIPT_DIR/lib"
fi

source "$LIB_DIR/services"
source "$LIB_DIR/downganize"
source "$LIB_DIR/config"

VER=1.4.0

write_default_config(){
    echo "[v$VER]" > ~/.config/downganizer.conf
    echo "CRITERIA=type" >> ~/.config/downganizer.conf
    echo "NESTED=false" >> ~/.config/downganizer.conf
    echo "DUPLICATES=overwrite" >> ~/.config/downganizer.conf
}

if [[ ! -e ~/.config/downganizer.conf ]]; then
    write_default_config
else
    prev_conf_file=$(head -n 1 ~/.config/downganizer.conf)
    if [[ "$prev_conf_file" != "[v$VER]" ]]; then
        write_default_config
    fi
fi

args=$(getopt -o hv --long help,version,dry-run -n "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    echo "Usage: $0 [-v | --version or -h | --help] [option]" >&2
    exit 1
fi

echo_version() {
    echo "Downganizer version $VER"
}

echo_help() {
    echo "Usage: downganizer [flags/option]
Flags:
    -v, --version         Show version information
    -h, --help            Show this help message
Options: 
    do          Organizes the Downloads directory now.
    start       Start the Downganizer service - monitors new Downloads.
    stop       Stop the Downganizer service.
    restart    Restart the Downganizer service.
    enable     Enable the Downganizer service to start on boot.
    disable    Disable the Downganizer service from starting on boot.
    status     Show the status of the Downganizer service."
}

eval set -- "$args"

version=false
help=false
either=false

# Extract arguments
while true; do
    case "$1" in
        -v|--version) version=true; shift ;;
        -h|--help) help=true; shift ;;
        --dry-run) shift ; shift ; # shifting dry-run and --
            if [[ "$1" != "do" ]]; then
                echo "The --dry-run flag can only be used with the 'do' option." >&2
                exit 1
            else
                downganize_dry
                exit 0
            fi
        ;;
        --) shift; break ;;
        *) echo "Internal error"; exit 1 ;;
    esac
done

# Execute the appropriate action
if [ "$version" = true ]; then
    echo_version
    either=true
fi
if [ "$help" = true ]; then
    echo_help
    either=true
fi

if [ "$either" = true ]; then
    exit 0
fi

if [[ $# -gt 1 && "$1" != "config" ]]; then
    echo "Too many arguments provided." >&2
    echo "Use -h or --help for usage information." >&2
    exit 1
fi

case $1 in
    "do") downganize ;;
    "start") dg_start ;;
    "stop") dg_stop ;;
    "restart") dg_restart ;;
    "enable") dg_enable ;;
    "disable") dg_disable ;;
    "status") dg_status ;;
    "config") shift; dg_config $@ ;;
    "") echo "No option provided. Use -h or --help for usage information." >&2; exit 1 ;;
    *) echo "Invalid option: $1" >&2; exit 1 ;;
esac
