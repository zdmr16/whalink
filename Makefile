.PHONY: help install start stop restart logs clean ssl status backup

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "🚀 Whalink - WhatsApp API Management"
	@echo "===================================="
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

install: ## Install and setup the project (first time only)
	@echo "📦 Installing Whalink..."
	@if [ ! -f .env ]; then \
		echo "⚙️  Creating .env file from .env.example..."; \
		cp .env.example .env; \
		echo "⚠️  Please edit .env file with your configurations!"; \
	fi
	@echo "🔐 Generating SSL certificates..."
	@./generate-ssl.sh
	@echo "✅ Installation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Edit .env file with your settings"
	@echo "  2. Run 'make start' to start the services"

ssl: ## Generate SSL certificates
	@echo "🔐 Generating SSL certificates..."
	@./generate-ssl.sh

start: ## Start all services
	@echo "🚀 Starting Whalink services..."
	@docker-compose up -d
	@echo "✅ Services started!"
	@echo ""
	@make status

stop: ## Stop all services
	@echo "🛑 Stopping Whalink services..."
	@docker-compose down
	@echo "✅ Services stopped!"

restart: ## Restart all services
	@echo "🔄 Restarting Whalink services..."
	@docker-compose restart
	@echo "✅ Services restarted!"

logs: ## Show logs (use 'make logs service=evolution-api' for specific service)
	@if [ -z "$(service)" ]; then \
		docker-compose logs -f; \
	else \
		docker-compose logs -f $(service); \
	fi

status: ## Show status of all services
	@echo "📊 Whalink Services Status:"
	@echo "=========================="
	@docker-compose ps
	@echo ""
	@echo "🌐 Access URLs:"
	@echo "  • Manager UI:        https://localhost"
	@echo "  • Evolution API:     https://localhost/api"
	@echo "  • Grafana:           https://localhost/grafana"
	@echo "  • Prometheus:        http://localhost:9091"

clean: ## Remove all containers, volumes and data (WARNING: This will delete all data!)
	@echo "⚠️  WARNING: This will delete all containers, volumes and data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "🗑️  Cleaning up..."; \
		docker-compose down -v; \
		rm -rf data/; \
		echo "✅ Cleanup complete!"; \
	else \
		echo "❌ Cleanup cancelled."; \
	fi

backup: ## Backup database and configuration
	@echo "💾 Creating backup..."
	@mkdir -p backups
	@timestamp=$$(date +%Y%m%d_%H%M%S); \
	backup_file="backups/whalink_backup_$$timestamp.tar.gz"; \
	tar -czf $$backup_file .env data/; \
	echo "✅ Backup created: $$backup_file"

update: ## Pull latest Docker images
	@echo "🔄 Updating Docker images..."
	@docker-compose pull
	@echo "✅ Images updated! Run 'make restart' to apply changes."

shell-api: ## Open shell in Evolution API container
	@docker-compose exec evolution-api /bin/sh

shell-db: ## Open PostgreSQL shell
	@docker-compose exec postgres psql -U evolution -d evolution
