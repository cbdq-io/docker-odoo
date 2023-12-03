FROM odoo:16

COPY --chown=755 healthcheck.sh /usr/local/bin/healthcheck.sh
COPY --chown=755 backup.sh /usr/local/bin/backup.sh
COPY --chown=755 restore.sh /usr/local/bin/restore.sh
