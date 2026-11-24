# Everyday commands. Run `make help` to list them.
VENV    := .venv
PY      := $(VENV)/bin/python
PIP     := $(VENV)/bin/pip

.DEFAULT_GOAL := help
.PHONY: help setup test lint fix run db-up db-viewer admin admin-secret seed db-down clean

help:  ## Show this list
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-10s %s\n", $$1, $$2}'

setup:  ## Create .venv and install dependencies and hooks
	python3 -m venv $(VENV)
	$(PIP) install --upgrade pip
	$(PIP) install -r backend/requirements-dev.txt ruff mypy pre-commit
	$(VENV)/bin/pre-commit install
	@if [ ! -f .env ]; then cp .env.example .env; echo "Created .env: add your own keys"; fi

test:  ## Run all backend
	$(PY) -m pytest

lint:  ## Lint (ruff) and type-check (mypy)
	$(VENV)/bin/ruff check backend
	-$(VENV)/bin/mypy

fix:  ## Auto-fix what ruff can fix
	$(VENV)/bin/ruff check --fix backend

run:  ## Start the API at http://localhost:8000 (docs at /docs)
	cd backend && ../$(VENV)/bin/uvicorn app.main:app --reload

db-up:  ## Start local PostgreSQL with Docker
	docker compose up -d db

db-viewer:  ## Start the web database viewer at http://localhost:8080, or ADMINER_PORT=8081 make db-viewer
	docker compose up -d db adminer

admin:  ## Make an existing user an admin (asks for a secret word): make admin EMAIL=you@example.com
	cd backend && ../$(VENV)/bin/python -m app.cli make-admin $(EMAIL)

admin-secret:  ## Change an admin's secret word: make admin-secret EMAIL=you@example.com
	cd backend && ../$(VENV)/bin/python -m app.cli set-secret $(EMAIL)

seed:  ## Create the demo users and the demo admin (the API must be running)
	$(PY) scripts/seed_demo.py

migrate:  ## Create or upgrade the database tables (Alembic)
	cd backend && ../$(VENV)/bin/alembic upgrade head

db-down:  ## Stop local PostgreSQL
	docker compose down

clean:  ## Remove caches
	find . -name __pycache__ -type d -prune -exec rm -rf {} +
	rm -rf .pytest_cache .ruff_cache .mypy_cache

start:  ## One command: fix ports, migrate, set admin, run everything
	./start-adbanao.sh

stop:  ## Free ports 8000 and 5173
	./stop-adbanao.sh
