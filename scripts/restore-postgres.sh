#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "" ]; then
  echo "Usage: ./scripts/restore-postgres.sh backups/aqarx-YYYYMMDD-HHMMSS.sql.gz"
  exit 1
fi

if [ "${CONFIRM_RESTORE:-}" != "yes" ]; then
  echo "Restore is destructive. Re-run with CONFIRM_RESTORE=yes to continue."
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ -f ".env.production" ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env.production
  set +a
fi

POSTGRES_CONTAINER="${POSTGRES_CONTAINER:-aqarx-postgres}"
POSTGRES_USER="${POSTGRES_USER:-aqarx}"
POSTGRES_DB="${POSTGRES_DB:-aqarx}"
BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "Restoring $BACKUP_FILE into $POSTGRES_DB..."
gunzip -c "$BACKUP_FILE" | docker exec -i -e PGPASSWORD="${POSTGRES_PASSWORD:-}" "$POSTGRES_CONTAINER" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"
echo "Restore complete."