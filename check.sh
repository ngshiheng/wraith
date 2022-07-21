#!/bin/bash

# check if ghost CLI is installed
check_ghost_installation() {
    if ! command -v ghost &>/dev/null; then
        log "$(ghost) could not be found"
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
