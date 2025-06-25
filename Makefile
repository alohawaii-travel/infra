# Alohawaii Development Makefile
# Simple commands to manage the Docker stack

.PHONY: help \
	setup setup-env update-vars gen-keys \
	start start-all start-hub stop restart \
	logs logs-api logs-hub status \
	shell-api shell-hub test migrate seed \
	clean rebuild \
	up down ps \
	setup-repos update-repos split-repos
.DEFAULT_GOAL := help

# Default target
help:
	@echo "🌺 Alohawaii Development Commands"
	@echo "================================="
	@echo ""
	@echo "Setup Commands:"
	@echo "  make setup       - Initial setup (build images, create network)"
	@echo "  make setup-env   - Setup environment files and generate secrets"
	@echo "  make update-vars - Sync variables between Hub and API environments"
	@echo "  make gen-keys    - Generate secure API keys for development"
	@echo ""
	@echo "Service Commands:"
	@echo "  make start       - Start default services (API + Database)"
	@echo "  make start-all   - Start all services (API + Hub + Database)"
	@echo "  make start-hub   - Start Hub with supporting services"
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
	@echo "\n🔧 Setting up environment files..."
	@$(MAKE) setup-env

# Setup environment files and generate secrets
setup-env:
	@./scripts/setup-environment.sh

# Update and sync environment variables between Hub and API
update-vars:
	@cd scripts && ./update-env-vars.sh

# Generate API keys
gen-keys:
	@./scripts/generate-api-keys.sh

# Service management
start start-all start-hub stop restart:
	@./docker-manager.sh $@

# Monitoring commands
logs logs-api logs-hub status:
	@./docker-manager.sh $@

# Development commands
shell-api shell-hub test migrate seed:
	@./docker-manager.sh $@

# Maintenance commands
clean rebuild:
	@./docker-manager.sh $@

# Quick shortcuts for common commands
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
