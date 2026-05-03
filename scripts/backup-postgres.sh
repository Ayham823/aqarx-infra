#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ -f ".env.production" ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env.production
  set +a
fi

POSTGRES_CONTAINER="${POSTGRES_CONTAINER:-qivro-postgres}"
POSTGRES_USER="${POSTGRES_USER:-qivro}"
POSTGRES_DB="${POSTGRES_DB:-qivro}"
BACKUP_DIR="${BACKUP_DIR:-$ROOT_DIR/backups}"
BACKUP_RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-14}"

mkdir -p "$BACKUP_DIR"
file="$BACKUP_DIR/qivro-$(date +%Y%m%d-%H%M%S).sql.gz"

echo "Writing backup to $file"
docker exec -e PGPASSWORD="${POSTGRES_PASSWORD:-}" "$POSTGRES_CONTAINER" pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" | gzip > "$file"

find "$BACKUP_DIR" -name "qivro-*.sql.gz" -mtime +"$BACKUP_RETENTION_DAYS" -delete

echo "Backup complete: $file"