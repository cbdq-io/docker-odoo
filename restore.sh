#!/bin/bash

BASE_URL='http://localhost:8069'
MAX_ATTEMPTS=6
PROG=$( basename "$0" )

while getopts "a:d:f:hm:u:" arg; do
  case $arg in
    a) ADMIN_PASSWORD="${OPTARG}" ;;
    d) DB_NAME="${OPTARG}" ;;
    f) FILE_NAME="${OPTARG}" ;;
    h)
      echo "usage: ${PROG} -a admin_password -d db_name -u base_URL"
      exit 0
      ;;
    m) MAX_ATTEMPTS="${OPTARG}" ;;
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

status=1
attempts=0

while (( status != 0 )); do
  curl -sL --fail "${BASE_URL}/web/health" > /dev/null
  status="$?"
  (( attempts += 1 ))

  if (( status == 0 )); then
    echo "INFO: Odoo is ready for a restore."
  elif (( attempts > MAX_ATTEMPTS )); then
    echo "ERROR: Odoo not ready on ${BASE_URL}"
    exit 1
  else
    echo "WARNING: Odoo on ${BASE_URL} is not ready (attempt ${attempts} of ${MAX_ATTEMPTS})."
    sleep 10
  fi
done

echo "INFO: Dropping DB ${DB_NAME}."
curl -sL -F "master_pwd=${ADMIN_PASSWORD}" \
  -F "name=${DB_NAME}" "${BASE_URL}/web/database/drop" > /dev/null
echo "INFO: Restoring DB ${DB_NAME} from file://${FILE_NAME}."
curl --fail -sL -F "master_pwd=${ADMIN_PASSWORD}" \
  -F "backup_file=@${FILE_NAME}" -F 'copy=true' \
  -F "name=${DB_NAME}" "${BASE_URL}/web/database/restore" > /dev/null
