.PHONY: build up down down-v logs ps prune help
.PHONY: logs-redis logs-mongodb logs-mysql logs-postgres logs-rabbitmq logs-elasticsearch logs-kibana
.PHONY: shell-redis shell-mongodb shell-mysql shell-postgres shell-rabbitmq

# Build and start all services
build:
	docker compose up --build -d --remove-orphans

# Start all services
up:
	docker compose up -d

# Stop all services
down:
	docker compose down

# Stop all services and remove volumes
down-v:
	docker compose down -v

# Show logs for all services
logs:
	docker compose logs -f

# Show logs for specific services
logs-redis:
	docker compose logs -f redis

logs-mongodb:
	docker compose logs -f mongodb

logs-mysql:
	docker compose logs -f mysql

logs-postgres:
	docker compose logs -f postgres

logs-rabbitmq:
	docker compose logs -f rabbitmq

logs-elasticsearch:
	docker compose logs -f elasticsearch

logs-kibana:
	docker compose logs -f kibana

# Shell access to services
shell-redis:
	docker compose exec redis redis-cli

shell-mongodb:
	docker compose exec mongodb mongosh -u admin -p admin

shell-mysql:
	docker compose exec mysql mysql -u admin -p jobportal

shell-postgres:
	docker compose exec postgres psql -U admin -d jobportal

shell-rabbitmq:
	docker compose exec rabbitmq rabbitmqctl

# Database backups
backup-mysql:
	docker compose exec mysql mysqldump -u admin -p jobportal > backup-mysql.sql

backup-postgres:
	docker compose exec postgres pg_dump -U admin jobportal > backup-postgres.sql

backup-mongodb:
	docker compose exec mongodb mongodump --out=/data/backup

# Database restores
restore-mysql:
	docker compose exec -T mysql mysql -u admin -p jobportal < backup-mysql.sql

restore-postgres:
	docker compose exec -T postgres psql -U admin jobportal < backup-postgres.sql

# Show running containers
ps:
	docker compose ps

# Prune all unused containers, networks, and volumes
prune:
	docker system prune -f
	docker volume prune -f

# Health check
health:
	@echo "Checking containers status:"
	docker compose ps
	@echo "\nChecking volumes:"
	docker volume ls
	@echo "\nChecking networks:"
	docker network ls | grep job-portal

# Help
help:
	@echo "Available commands:"
	@echo "  make build              - Build and start all services"
	@echo "  make up                - Start all services"
	@echo "  make down              - Stop all services"
	@echo "  make down-v            - Stop all services and remove volumes"
	@echo "  make logs              - Show logs for all services"
	@echo "  make logs-<service>    - Show logs for specific service"
	@echo "  make shell-<service>   - Access shell for specific service"
	@echo "  make backup-<db>       - Backup specific database"
	@echo "  make restore-<db>      - Restore specific database"
	@echo "  make ps                - Show running containers"
	@echo "  make prune             - Remove unused Docker resources"
	@echo "  make health            - Show health status of services"
	@echo "\nAvailable services:"
	@echo "  redis, mongodb, mysql, postgres, rabbitmq, elasticsearch, kibana"