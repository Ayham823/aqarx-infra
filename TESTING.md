# Qivro E2E And Smoke Testing

These tests run against the real local Docker stack. Use them to verify that
backend, frontend, admin, AI, and Postgres work together.

## Start The Stack

```bash
cd ~/aqarx-infra
docker compose -f docker-compose.dev.yml up -d --build
```

## Run Everything

```bash
cd ~/aqarx-infra
npm run smoke
```

This runs API smoke first, then UI smoke.

## API E2E Smoke

```bash
npm run smoke:api
```

This creates unique test users and checks:

- register/login
- listings list/create/delete
- listing view tracking
- favorites
- leads
- report listing
- trust summary
- saved searches
- messaging
- payment checkout and confirmation

## UI Smoke

```bash
npm run smoke:ui
```

This checks:

- public frontend pages on `http://localhost:3000`
- internal admin pages on `http://localhost:3002`
- `/admin/analytics` on the public app returns `404`

## Custom URLs

```bash
API_URL=http://localhost:3001/api npm run smoke:api
FRONTEND_URL=http://localhost:3000 ADMIN_URL=http://localhost:3002 npm run smoke:ui
```

## Test Mode Safety

The API smoke runner sends this header by default:

```http
x-qivro-test-mode: true
```

Backend notifications created by smoke-test listings are routed to admins only,
so regular users do not receive test saved-search alerts or emails.

To deliberately run without the test-mode header:

```bash
SMOKE_TEST_MODE=false npm run smoke:api
```

## Recommended Workflow

After backend-only changes:

```powershell
cd C:\Users\Win11\real-estate-backend
npm run test:critical
npm run build
```

After full-stack changes:

```bash
cd ~/aqarx-infra
docker compose -f docker-compose.dev.yml up -d --build
npm run smoke
```

Before deploy:

```powershell
cd C:\Users\Win11\real-estate-backend
npm test
npm run build
```

```bash
cd ~/aqarx-infra
npm run smoke
```
