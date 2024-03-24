TAG := $(shell date -u +"16-%Y%m%dT%HZ" )

all: lint build test

build:
	docker build \
          --tag odoo:latest \
	  --tag ghcr.io/cbdq-io/odoo:latest \
	  --tag ghcr.io/cbdq-io/odoo:$(TAG) \
	  .

clean:
	docker compose down -t 0

lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

pushLatest:
	docker push ghcr.io/cbdq-io/odoo:latest

pushTag:
	docker push ghcr.io/cbdq-io/odoo:$(TAG)

releaseBranch:
	git flow release start $(TAG)

test:
	docker compose up -d --wait odoo
	docker compose exec odoo /usr/local/bin/restore.sh -a secret -d odoo -f /mnt/restore/odoo.zip
	docker compose exec odoo /usr/local/bin/backup.sh -a secret -d odoo -f /tmp/test-backup.zip
	docker compose exec odoo ls -l /tmp/test-backup.zip

trivy:
	trivy image --ignore-unfixed odoo:latest

update-trivy-ignore:
	trivy image --format json --ignore-unfixed --severity HIGH,CRITICAL odoo:latest | jq -r '.Results[1].Vulnerabilities[].VulnerabilityID' | sort -u | tee .trivyignore
