#!/usr/bin/env bash

MYSQL_USER="root"
MYSQL_PASSWORD="password"
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="33060"
MYSQL_DB="employees"

BACKUP_DIR="$HOME/mysql_backups/"

cmd_help ()
{
  echo "Usage:"
  echo "  -h"
  echo "    display this help"
  echo "  -l"
  echo "    list backup files"
  echo "  -r [file]"
  echo "    restore file to mysql, restore most recent backup if blank"
  echo "  -b"
  echo "    backup mysql"
}

cmd_backup ()
{
  mysqldump --host="${MYSQL_HOST}" --port=${MYSQL_PORT} --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}" "${MYSQL_DB}" > "${BACKUP_DIR}/${MYSQL_DB}_$(date +%Y%m%d%H%M%S).sql"
}

cmd_latest_file ()
{
  ls -t "${BACKUP_DIR}" | head -n 1
}

cmd_restore ()
{
  if [[ ! -z "$1" ]]
  then
    echo "restoring ""$1";
    mysql --host="${MYSQL_HOST}" --port=${MYSQL_PORT} --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}" "${MYSQL_DB}" < "${BACKUP_DIR}/$1";
  else
    echo "$(cmd_latest_file)";
    mysql --host="${MYSQL_HOST}" --port=${MYSQL_PORT} --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}" "${MYSQL_DB}" < "${BACKUP_DIR}""$(cmd_latest_file)";
  fi
}

cmd_list_file ()
{
  ls -1 "${BACKUP_DIR}"
}

case "$1" in
  -h) shift; cmd_help ;;
  -b) shift; cmd_backup ;;
  -r) shift; cmd_restore "$@" ;;
  -l) shift; cmd_list_file ;;
	*) echo "see -h" ;;
esac
exit 0
