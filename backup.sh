#!/bin/bash

set -e

source check.sh
source util.sh

GHOST_DIR="var/www/ghost"
TIMESTAMP=$(date +%Y_%m_%d_%H%M)

# backup Ghost content folder
backup_ghost_content() {
    log "Dumping Ghost content..."
    cd $GHOST_DIR

    tar -czf ghost_content_"$TIMESTAMP".tar.gz content/
}
