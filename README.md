# AqarX Infra

Local Docker Compose stack for AqarX.

## Services

| Service | URL |
| --- | --- |
| Public frontend | `http://localhost:3000` |
| Backend API | `http://localhost:3001/api` |
| Admin app | `http://localhost:3002` |
| AI service | `http://localhost:8000` |
| Postgres | `localhost:5434` |

## Start The Full Stack

```bash
cd ~/aqarx-infra
docker compose -f docker-compose.dev.yml up -d --build
```

## Stop The Stack

```bash
cd ~/aqarx-infra
docker compose -f docker-compose.dev.yml down
```

## Full Smoke Test

Run this before deploy, after big changes, or when you want to verify the full
system:

```bash
cd ~/aqarx-infra
npm run smoke
```

## Split Smoke Commands

```bash
npm run smoke:api
npm run smoke:ui
```

## What Smoke Tests Check

API smoke checks:

- register/login
- listings list/create/delete
- listing view tracking
- favorites
- leads
- reports
- trust summary
- saved searches
- messaging
- payment checkout and confirmation

UI smoke checks:

- public frontend pages on `3000`
- internal admin pages on `3002`
- public `/admin/analytics` returns `404`

## Test Mode Safety

The API smoke runner sends:

```http
x-aqarx-test-mode: true
```

Smoke-test listing notifications and emails are routed to admins only, not to
regular users.

## More Testing Details

See [TESTING.md](./TESTING.md).
