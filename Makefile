# =========
# Variables
# =========
BACKEND_DIR=backend
APP_MODULE=app.main:app
PORT=8000
ENV_FILE=.env
ENV_EXAMPLE=.env.example


# =========
# Auto-setup
# =========
# Creates .env from .env.example if not found
$(ENV_FILE):
	@if [ ! -f "$(ENV_EXAMPLE)" ]; then \
		echo ">> ERROR: $(ENV_EXAMPLE) is missing. Creating with required variables."; \
		exit 1; \
	fi
	@if [ ! -f "$(ENV_FILE)" ]; then \
		cp "$(ENV_EXAMPLE)" "$(ENV_FILE)"; \
		echo ">> Created $(ENV_FILE) using $(ENV_EXAMPLE)"; \
	else \
		echo ">> $(ENV_FILE) already exists. OK"; \
	fi

# Sincroniza dependencias del backend con Rye (requiere rye instalado)
backend-sync:
	@command -v rye >/dev/null 2>&1 || { \
		echo ">> ERROR: Rye not installed. Install it using:"; \
		echo "   curl -sSf https://rye-up.com/get | bash"; \
		exit 1; \
	}
	@echo ">> Sinchronizing dependencies with Rye..."
	@cd $(BACKEND_DIR) && rye sync


# =========
# Commands
# =========

# Dev server with Rye
dev-backend: $(ENV_FILE) backend-sync
	@echo ">> Launching Uvicorn with Rye in :$(PORT) ..."
	cd $(BACKEND_DIR) && rye run uvicorn $(APP_MODULE) --reload --host 0.0.0.0 --port $(PORT)

# Dev backend w/ Docker Compose
docker-backend:
	docker compose up --build backend

# DB + backend (+ frontend [WiP])
docker-up:
	docker compose up --build

# Stop every docker-compose services
docker-down:
	docker compose down

# See Docker backend logs
logs-backend:
	docker compose logs -f backend

# Clean volumes and containers (⚠️ deletes BDs)
docker-clean:
	docker compose down -v --remove-orphans

# =========
# Conveniences
# =========
# Does the full setup: 1) .env  2) rye sync
setup: $(ENV_FILE) backend-sync
	@echo ">> Setup complete."

help:
	@echo "Available targets:"
	@echo "  setup           -> Creates .env y runs 'rye sync'"
	@echo "  dev-backend     -> Launches backend (Rye + Uvicorn --reload)"
	@echo "  docker-backend  -> Only launches backend in Docker"
	@echo "  docker-up       -> Launches DB + backend (and frontend when available)"
	@echo "  docker-down     -> Stops services"
	@echo "  logs-backend    -> Backend logs"
	@echo "  docker-clean    -> Clean volumes and containers (⚠️ deletes BDs)"
	
.PHONY: dev-backend docker-backend docker-up docker-down logs-backend docker-clean
