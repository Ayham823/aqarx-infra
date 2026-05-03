#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "" ]; then
  echo "Usage: ./scripts/restore-postgres.sh backups/<env>/qivro-<env>-YYYYMMDD-HHMMSS.sql.gz"
  exit 1
fi

if [ "${CONFIRM_RESTORE:-}" != "yes" ]; then
  echo "Restore is destructive. Re-run with CONFIRM_RESTORE=yes to continue."
  exit 1
fi

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
BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "Restoring $BACKUP_FILE into $POSTGRES_DB on $DEPLOY_ENV..."
gunzip -c "$BACKUP_FILE" | docker exec -i -e PGPASSWORD="${POSTGRES_PASSWORD:-}" "$POSTGRES_CONTAINER" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
echo "Restore complete."