#!/bin/bash

# log writes message to stdout with a timestamp
log() {
    echo "$(date -u): $1"
}

# check if command is installed
check_command_installation() {
    if ! command -v $1 &>/dev/null; then
        log "$1 is not installed"
        exit 0
    fi
}

# check if Ghost is running
check_ghost_status() {
    if ! ghost status &>/dev/null; then
        log "Ghost is not running"
        exit 0
    fi
}
