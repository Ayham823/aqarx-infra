#!/usr/bin/env bash
set -euo pipefail

DEPLOY_DIR="${DEPLOY_DIR:-$HOME/aqarx-infra}"
COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.prod.yml}"
BACKUP_BEFORE_DEPLOY="${BACKUP_BEFORE_DEPLOY:-true}"

cd "$DEPLOY_DIR"

if [ ! -f ".env.production" ]; then
  echo "Missing .env.production. Copy .env.production.example and fill production values first."
  exit 1
fi

if [ "$BACKUP_BEFORE_DEPLOY" = "true" ] && [ -x "./scripts/backup-postgres.sh" ]; then
  echo "Creating database backup before deploy..."
  ./scripts/backup-postgres.sh || echo "Backup skipped or failed; continuing deploy because app may be first-time setup."
fi

echo "Pulling latest infra repo..."
git pull --ff-only

echo "Building production images..."
docker compose -f "$COMPOSE_FILE" --env-file .env.production build

echo "Starting/updating services..."
docker compose -f "$COMPOSE_FILE" --env-file .env.production up -d --remove-orphans

echo "Current service status:"
docker compose -f "$COMPOSE_FILE" --env-file .env.production ps