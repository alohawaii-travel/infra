# Alohawaii Development Makefile
# Simple commands to manage the Docker stack

.PHONY: help setup start start-all start-api start-hub stop restart logs status clean rebuild test setup-repos update-repos split-repos
.DEFAULT_GOAL := help

# Default target
help:
	@echo "🌺 Alohawaii Development Commands"
	@echo "================================="
	@echo ""
	@echo "Setup Commands:"
	@echo "  make setup       - Initial setup (build images, create network)"
	@echo ""
	@echo "Service Commands:"
	@echo "  make start       - Start API + Database"
	@echo "  make start-all   - Start API + Hub + Database"
	@echo "  make start-api   - Start API + Database only"
	@echo "  make start-hub   - Start Hub + API + Database"
	@echo "  make stop        - Stop all services"
	@echo "  make restart     - Restart all services"
	@echo ""
	@echo "Monitoring Commands:"
	@echo "  make logs        - Show logs from all services"
	@echo "  make logs-api    - Show API logs"
	@echo "  make logs-hub    - Show Hub logs"
	@echo "  make status      - Show service status"
	@echo ""
	@echo "Development Commands:"
	@echo "  make shell-api   - Open shell in API container"
	@echo "  make shell-hub   - Open shell in Hub container"
	@echo "  make test        - Run API tests"
	@echo "  make migrate     - Run database migrations"
	@echo "  make seed        - Seed database"
	@echo ""
	@echo "Maintenance Commands:"
	@echo "  make clean       - Remove all containers and data"
	@echo "  make rebuild     - Rebuild and restart everything"
	@echo ""
	@echo "Repository Commands:"
	@echo "  make setup-repos - Clone API and Hub repositories"
	@echo "  make update-repos - Update API and Hub repositories"
	@echo "  make split-repos - Split current project into separate repositories"

# Setup
setup:
	@./docker-manager.sh setup

# Service management
start:
	@./docker-manager.sh start

start-all:
	@./docker-manager.sh start-all

start-api:
	@./docker-manager.sh start-api

start-hub:
	@./docker-manager.sh start-hub

stop:
	@./docker-manager.sh stop

restart:
	@./docker-manager.sh restart

# Monitoring
logs:
	@./docker-manager.sh logs

logs-api:
	@./docker-manager.sh logs-api

logs-hub:
	@./docker-manager.sh logs-hub

status:
	@./docker-manager.sh status

# Development
shell-api:
	@./docker-manager.sh shell-api

shell-hub:
	@./docker-manager.sh shell-hub

test:
	@./docker-manager.sh test

migrate:
	@./docker-manager.sh migrate

seed:
	@./docker-manager.sh seed

# Maintenance
clean:
	@./docker-manager.sh clean

rebuild:
	@./docker-manager.sh rebuild

# Quick shortcuts
up: start
down: stop
ps: status

# Repository management
setup-repos:
	@echo "🔧 Setting up service repositories..."
	@./scripts/setup-services.sh

update-repos:
	@echo "🔄 Updating service repositories..."
	@./scripts/update-services.sh

split-repos:
	@echo "📂 Splitting project into separate repositories..."
	@./scripts/split-repositories.sh
