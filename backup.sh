#!/bin/sh -e

BASE_URL='http://localhost:8069'

while getopts "a:d:f:u:" arg; do
  case $arg in
    a) ADMIN_PASSWORD="${OPTARG}" ;;
    d) DB_NAME="${OPTARG}" ;;
    f) FILE_NAME="${OPTARG}" ;;
    h)
      echo "usage: $( basname $0 ) -a admin_password -d db_name -u base_URL" 
      exit 0
      ;;
    u) BASE_URL="${OPTARG}" ;;
    *) exit 2 ;;
  esac
done

if [ -z "$ADMIN_PASSWORD" ]; then
  echo "ERROR: ADMIN_PASSWORD is not defined."
  exit 1
fi

if [ -z "$DB_NAME" ]; then
  echo "ERROR: DB_NAME is not defined."
  exit 1
fi

if [ -z "$FILE_NAME" ]; then
  echo "ERROR: FILE_NAME is not defined."
  exit 1
fi

if [ -z "$BASE_URL" ]; then
  echo "ERROR: BASE_URL is not defined."
  exit 1
fi

curl -v -X POST \
  -F "master_pwd=${ADMIN_PASSWORD}" \
  -F "name=${DB_NAME}" \
  -F "backup_format=zip" \
  -o "${FILE_NAME}" \
  "${BASE_URL}/web/database/backup"
