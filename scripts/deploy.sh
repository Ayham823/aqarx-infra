#!/usr/bin/env bash
set -euo pipefail

DEPLOY_DIR="${DEPLOY_DIR:-$HOME/aqarx-infra}"
DEPLOY_ENV="${DEPLOY_ENV:-production}"
COMPOSE_FILE="${COMPOSE_FILE:-docker-compose.prod.yml}"
ENV_FILE="${ENV_FILE:-.env.$DEPLOY_ENV}"
COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-qivro-$DEPLOY_ENV}"
BACKUP_BEFORE_DEPLOY="${BACKUP_BEFORE_DEPLOY:-true}"
RUN_MIGRATIONS="${RUN_MIGRATIONS:-true}"

cd "$DEPLOY_DIR"

if [ ! -f "$ENV_FILE" ]; then
  echo "Missing $ENV_FILE. Copy .env.$DEPLOY_ENV.example and fill real values first."
  exit 1
fi

set -a
# shellcheck disable=SC1090
. "./$ENV_FILE"
set +a

export ENV_FILE
export COMPOSE_PROJECT_NAME
export CONTAINER_PREFIX="${CONTAINER_PREFIX:-qivro-$DEPLOY_ENV}"

if [ "$BACKUP_BEFORE_DEPLOY" = "true" ] && [ -x "./scripts/backup-postgres.sh" ]; then
  echo "Creating database backup before deploy for $DEPLOY_ENV..."
  DEPLOY_ENV="$DEPLOY_ENV" \
  ENV_FILE="$ENV_FILE" \
  COMPOSE_PROJECT_NAME="$COMPOSE_PROJECT_NAME" \
  CONTAINER_PREFIX="$CONTAINER_PREFIX" \
  ./scripts/backup-postgres.sh || echo "Backup skipped or failed; continuing deploy because app may be first-time setup."
fi

echo "Pulling latest infra repo..."
git pull --ff-only || echo "Infra git pull skipped or failed; continuing with current checked-out files."

echo "Pulling ready Docker images for $DEPLOY_ENV..."
docker compose -p "$COMPOSE_PROJECT_NAME" -f "$COMPOSE_FILE" --env-file "$ENV_FILE" pull

echo "Starting/updating $DEPLOY_ENV services..."
docker compose -p "$COMPOSE_PROJECT_NAME" -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d --remove-orphans

if [ "$RUN_MIGRATIONS" = "true" ]; then
  BACKEND_CONTAINER="${CONTAINER_PREFIX}-backend"

  echo "Waiting for backend container: $BACKEND_CONTAINER..."
  sleep 5

  if docker ps --format '{{.Names}}' | grep -qx "$BACKEND_CONTAINER"; then
    echo "Running Prisma migrations..."
    docker exec "$BACKEND_CONTAINER" npx prisma migrate deploy || {
      echo "Prisma migrations failed."
      echo "Check backend logs with: docker logs --tail 120 $BACKEND_CONTAINER"
      exit 1
    }
  else
    echo "Backend container is not running; skipping migrations."
    docker compose -p "$COMPOSE_PROJECT_NAME" -f "$COMPOSE_FILE" --env-file "$ENV_FILE" ps
    exit 1
  fi
fi

NGINX_CONTAINER="${CONTAINER_PREFIX}-nginx"

if docker ps --format '{{.Names}}' | grep -qx "$NGINX_CONTAINER"; then
  echo "Restarting nginx..."
  docker restart "$NGINX_CONTAINER" >/dev/null
fi

echo "Current $DEPLOY_ENV service status:"
docker compose -p "$COMPOSE_PROJECT_NAME" -f "$COMPOSE_FILE" --env-file "$ENV_FILE" ps

echo "Deployment complete."