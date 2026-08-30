include .env
export

up:
	@docker compose up -d

down:
	@docker compose down

db-clear:
	@read -p "очистить всю базу данных? [y/N]: " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down todoapp-postgres; \
		rm -rf ./out/pgdata; \
		echo "база данных очищена"; \
	else \
		echo "очистка базы данных отменена"; \
	fi

port-forward:
	@docker compose up -d port-forwarder

# Пример: make create-migrate name=init_tables
create-migrate:
	@docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq $(name)

# Пример: make migrate action=up  ИЛИ  make migrate action=down
migrate:
	@docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todoapp-postgres:5432/${POSTGRES_DB}?sslmode=disable \
		$(action)
