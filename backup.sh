#!/bin/bash

set -eu

source util.sh

TIMESTAMP=$(date +%Y-%m-%d-%H%M)
GHOST_DIR="/var/www/ghost/"
GHOST_MYSQL_BACKUP_FILENAME="backup-from-mysql-$TIMESTAMP.sql.gz"
REMOTE_BACKUP_LOCATION="Ghost Backups/"

# run checks
pre_backup_checks() {
    if [ ! -d "$GHOST_DIR" ]; then
        log "Ghost directory does not exist"
        exit 0
    fi

    log "Running pre-backup checks"
    cd $GHOST_DIR

    cli=("expect" "gzip" "mysql" "mysqldump" "ghost" "rclone")
    for c in "${cli[@]}"; do
        check_command_installation "$c"
    done
    check_ghost_status
}

# backup Ghost content folder
backup_ghost_content() {
    log "Running ghost backup..."
    cd $GHOST_DIR

    expect wraith.exp
}

# check MySQL connection
check_mysql_connection() {
    log "Checking MySQL connection..."
    if ! mysql -u"$mysql_user" -p"$mysql_password" -e ";" &>/dev/null; then
        log "Could not connect to MySQL"
        exit 0
    fi
    log "MySQL connection OK"
}

# backup MySQL database
backup_mysql() {
    log "Backing up MySQL database..."
    cd $GHOST_DIR

    mysql_user=$(ghost config get database.connection.user | tail -n1)
    mysql_password=$(ghost config get database.connection.password | tail -n1)
    mysql_database=$(ghost config get database.connection.database | tail -n1)

    check_mysql_connection

    log "Dumping MySQL database..."
    mysqldump -u"$mysql_user" -p"$mysql_password" "$mysql_database" --no-tablespaces | gzip >"$GHOST_MYSQL_BACKUP_FILENAME"
}

# `rclone` backup
# assumes that `rclone config` is configured
rclone_to_cloud_storage() {
    log "Rclone backup..."
    cd $GHOST_DIR

    rclone_remote_name="remote" # TODO: parse from config or prompt

    rclone copy backup-from-*-on-*.zip "$rclone_remote_name:$REMOTE_BACKUP_LOCATION"
    rclone copy "$GHOST_MYSQL_BACKUP_FILENAME" "$rclone_remote_name:$REMOTE_BACKUP_LOCATION"
}

# clean up old backups
clean_up() {
    log "Cleaning up backups..."
    cd $GHOST_DIR

    rm -rf backup/
    rm -f backup-from-*-on-*.zip
    rm -f "$GHOST_MYSQL_BACKUP_FILENAME"
}

# main entrypoint of the script
main() {
    log "Welcome to wraith"
    pre_backup_checks
    clean_up
    backup_ghost_content
    backup_mysql
    rclone_to_cloud_storage
    clean_up
    log "Completed backup to $REMOTE_BACKUP_LOCATION"
}

main
