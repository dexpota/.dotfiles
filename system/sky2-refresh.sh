#!/bin/bash
# Install this script inside /lib/systemd/system-sleep/, if you want to find
# out more see the man page for systemd-sleep
# see https://askubuntu.com/a/1030154/853462

PROGNAME=$(basename "$0")
state=$1
action=$2

function log {
    logger -i -t "$PROGNAME" "$*"
}

log "Running $action $state"

if [[ $state == post ]]; then
    modprobe -r sky2 \
    && log "Removed sky2" \
    && modprobe -i sky2 \
    && log "Inserted sky2"
fi
