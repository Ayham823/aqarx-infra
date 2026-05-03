#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEPLOY_ENV="${DEPLOY_ENV:-production}"
ENV_FILE="${ENV_FILE:-.env.$DEPLOY_ENV}"

if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  . "./$ENV_FILE"
  set +a
elif [ -f ".env.production" ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env.production
  set +a
fi

CONTAINER_PREFIX="${CONTAINER_PREFIX:-qivro-$DEPLOY_ENV}"
POSTGRES_CONTAINER="${POSTGRES_CONTAINER:-$CONTAINER_PREFIX-postgres}"
POSTGRES_USER="${POSTGRES_USER:-qivro}"
POSTGRES_DB="${POSTGRES_DB:-qivro}"
BACKUP_DIR="${BACKUP_DIR:-$ROOT_DIR/backups/$DEPLOY_ENV}"
BACKUP_RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-14}"

mkdir -p "$BACKUP_DIR"
file="$BACKUP_DIR/qivro-$DEPLOY_ENV-$(date +%Y%m%d-%H%M%S).sql.gz"

echo "Writing backup to $file"
docker exec -e PGPASSWORD="${POSTGRES_PASSWORD:-}" "$POSTGRES_CONTAINER" pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" | gzip > "$file"

find "$BACKUP_DIR" -name "qivro-$DEPLOY_ENV-*.sql.gz" -mtime +"$BACKUP_RETENTION_DAYS" -delete

echo "Backup complete: $file"