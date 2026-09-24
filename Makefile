.PHONY: help up down restart ps logs pull sync sync-push n8n-import hermes-restore

help:
	@echo "make up             - jalankan Multica + Hermes + n8n"
	@echo "make down           - hentikan semua"
	@echo "make ps | logs      - status / log"
	@echo "make pull           - tarik image terbaru"
	@echo "make sync           - tarik konfigurasi dari VPS ke repo (di-stage)"
	@echo "make sync-push      - sync + commit + push"
	@echo "make n8n-import     - import n8n/workflows/*.json ke n8n"
	@echo "make hermes-restore - salin konfigurasi Hermes dari repo ke ~/.hermes"

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

ps:
	docker compose ps

logs:
	docker compose logs -f --tail=100

pull:
	docker compose pull

sync:
	./scripts/sync-from-vps.sh

sync-push:
	./scripts/sync-from-vps.sh --push

n8n-import:
	docker exec n8n n8n import:workflow --separate --input=/workflows

hermes-restore:
	./scripts/hermes-restore.sh
