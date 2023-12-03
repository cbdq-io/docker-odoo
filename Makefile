all: lint build test

build:
	docker build --tag odoo:latest .

clean:
	docker compose down -t 0

lint:
	docker run --rm -i hadolint/hadolint < Dockerfile

test:
	docker compose up -d --wait odoo
	docker compose exec odoo /usr/local/bin/restore.sh -a secret -d odoo -f /mnt/restore/odoo.zip
	docker compose exec odoo /usr/local/bin/backup.sh -a secret -d odoo -f /tmp/test-backup.zip
	docker compose exec odoo ls -l /tmp/test-backup.zip
