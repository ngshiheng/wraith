#!/bin/bash

set -e

source check.sh
source util.sh

GHOST_DIR="/var/www/ghost/"
TIMESTAMP=$(date +%Y_%m_%d_%H%M)
BACKUP_LOCATION="ghost_backups/"

GHOST_CONTENT_BACKUP_FILENAME="ghost_content_$TIMESTAMP.tar.gz"
GHOST_MYSQL_BACKUP_FILENAME="ghost_mysql_$TIMESTAMP.sql.gz"

# backup Ghost content folder
backup_ghost_content() {
    log "Dumping Ghost content..."
    cd $GHOST_DIR

    tar -czf "$GHOST_CONTENT_BACKUP_FILENAME" content/
}

# backup MySQL database
backup_mysql() {
    log "Backing up MySQL database"
    cd $GHOST_DIR

    mysql_user=$(ghost config get database.connection.user | tail -n1)
    mysql_password=$(ghost config get database.connection.password | tail -n1)
    mysql_database=$(ghost config get database.connection.database | tail -n1)

    check_mysql_connection

    log "Dumping MySQL database..."
    mysqldump -u"$mysql_user" -p"$mysql_password" "$mysql_database" --no-tablespaces | gzip >"$GHOST_MYSQL_BACKUP_FILENAME"
}

# `rclone` backup
# assumes that user already has rclone configured
rclone_to_cloud_storage() {
    log "Rclone backup..."
    cd $GHOST_DIR

    rclone copy "$GHOST_DIR/$GHOST_CONTENT_BACKUP_FILENAME" remote:$BACKUP_LOCATION
    rclone copy "$GHOST_DIR/$GHOST_MYSQL_BACKUP_FILENAME" remote:$BACKUP_LOCATION
}

# clean up old backups
clean_up() {
    log "Cleaning up old backups..."
    rm -r "$GHOST_DIR/$GHOST_CONTENT_BACKUP_FILENAME"
    rm -r "$GHOST_DIR/$GHOST_MYSQL_BACKUP_FILENAME"
}

log "Welcome to Wraith"
backup_ghost_content
backup_mysql
rclone_to_cloud_storage
log "Completed backup to $BACKUP_LOCATION"
