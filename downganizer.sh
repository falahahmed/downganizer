#!/bin/bash
# Parse arguments using getopt (GNU version)

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

source "$SCRIPT_DIR/lib/services.sh"
source "$SCRIPT_DIR/lib/downganize.sh"

VER=1.1.1

args=$(getopt -o hv --long help,version -n "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    echo "Usage: $0 [-v | --version or -h | --help] [option]" >&2
    exit 1
fi

echo_version() {
    echo "Downganizer version $VER"
}

echo_help() {
    echo "Usage: downganizer [flags/option]"
    echo "Options:"
    echo "  -v, --version         Show version information"
    echo "  -h, --help            Show this help message"
    echo "  downganizer do          Organizes the Downloads directory now."
    echo "  downganizer start       Start the Downganizer service - monitors new Downloads"
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

if [ $# -gt 1 ]; then
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
    "") echo "No option provided. Use -h or --help for usage information." >&2; exit 1 ;;
    *) echo "Invalid option: $1" >&2; exit 1 ;;
esac
