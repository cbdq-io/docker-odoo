#!/bin/sh

set -e

wait-for-psql.py \
  --db_host "${HOST}" \
  --db_port "${PORT}" \
  --db_user "${USER}" \
  --db_password "${PASSWORD}" \
  --timeout=5

curl --fail --silent localhost:8069/web/health > /dev/null
