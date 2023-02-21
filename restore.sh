#!/bin/bash

source util.sh

# restore MySQL database
# assumes that Ghost is installed
restore_mysql() {
    log "Restoring MySQL database..."
    cd "$GHOST_DIR" || exit

    mysql_user=$(ghost config get database.connection.user | tail -n1)
    mysql_password=$(ghost config get database.connection.password | tail -n1)
    mysql_database=$(ghost config get database.connection.database | tail -n1)

    check_mysql_connection

    log "Restoring MySQL database..."
    gunzip -c "$GHOST_MYSQL_BACKUP_FILENAME" | mysql -u"$mysql_user" -p"$mysql_password" "$mysql_database"
}
