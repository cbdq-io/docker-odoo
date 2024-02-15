#!/bin/sh

set -ex

wait-for-psql.py \
  --db_host "${HOST}" \
  --db_port "${PORT}" \
  --db_user "${USER}" \
  --db_password "${PASSWORD}" \
  --timeout=5

curl --fail --silent http://localhost:8069/web_editor/static/src/xml/ace.xml > /dev/null
