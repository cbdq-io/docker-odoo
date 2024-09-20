FROM odoo:17

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

COPY --chmod=755 healthcheck.sh /usr/local/bin/healthcheck.sh
COPY --chmod=755 backup.sh /usr/local/bin/backup.sh
COPY --chmod=755 restore.sh /usr/local/bin/restore.sh

# hadolint ignore=DL3008
RUN apt-get clean \
  && apt-get update \
  && apt-get upgrade -y --no-install-recommends --only-upgrade \
  && apt-get install --no-install-recommends --yes awscli \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER odoo
