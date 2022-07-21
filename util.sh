#!/bin/bash

# log writes message to stdout with a timestamp
log() {
    echo "$(date -u): $1" | tee -a $LOG_LOCATION
}
