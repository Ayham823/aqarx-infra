# Qivro Infra

Infrastructure workspace for running Qivro locally and preparing production deployment.

## Services

| Service | Local URL |
| --- | --- |
| Public frontend | `http://localhost:3000` |
| Backend API | `http://localhost:3001/api` |
| Admin app | `http://localhost:3002` |
| AI service | `http://localhost:8000` |
| Postgres | `localhost:5434` |

## Local Development

```bash
cd ~/aqarx-infra
docker compose -f docker-compose.dev.yml up -d --build
```

Stop local stack:

```bash
docker compose -f docker-compose.dev.yml down
```

## Smoke Tests

Run this before deploy, after big changes, or when you want to verify the full system:

```bash
npm run smoke
```

Split commands:

```bash
npm run smoke:api
npm run smoke:ui
```

API smoke checks auth, listings, views, favorites, leads, reports, trust, saved searches, messaging, and payments.

UI smoke checks public pages on `3000`, admin pages on `3002`, and confirms public `/admin/analytics` returns `404`.

The API smoke runner sends `x-qivro-test-mode: true`, so smoke-test listing notifications and emails are routed to admins only.

## Production Files

| File | Purpose |
| --- | --- |
| `docker-compose.prod.yml` | Production-style Docker stack |
| `.env.production.example` | Server-only env template |
| `nginx/templates/qivro-http.conf.template` | First HTTP reverse proxy template |
| `nginx/ssl-templates/qivro.conf.template` | HTTPS reverse proxy template after Certbot |
| `scripts/deploy.sh` | Pull, build, and update production services |
| `scripts/backup-postgres.sh` | Manual DB backup |
| `scripts/restore-postgres.sh` | Confirmed DB restore |
| `scripts/server-bootstrap.sh` | First-time Ubuntu server setup |

## Documentation

- [Testing](./TESTING.md)
- [DevOps Status](./docs/DEVOPS_STATUS.md)
- [Environment Strategy](./docs/ENVIRONMENTS.md)
- [Deployment Guide](./docs/DEPLOYMENT.md)