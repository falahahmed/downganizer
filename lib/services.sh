#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

dg_start () {
    $SCRIPT_DIR/lib/monitor.sh
}

dg_stop () {
    echo ;
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