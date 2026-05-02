# AqarX E2E And Smoke Testing

These tests run against the real local Docker stack.

## Start The Stack

```bash
docker compose -f docker-compose.dev.yml up -d --build
```

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

The API smoke runner sends `x-aqarx-test-mode: true` by default. Backend
notifications created by smoke-test listings are routed to admins only, so
regular users do not receive test saved-search alerts or emails.

## UI Smoke

```bash
npm run smoke:ui
```

This checks public frontend pages on `3000`, internal admin pages on `3002`,
and confirms `/admin/analytics` is not available in the public app.

## Full Smoke

```bash
npm run smoke
```

Run this after big changes or before pushing/deploying.

## Custom URLs

```bash
API_URL=http://localhost:3001/api npm run smoke:api
FRONTEND_URL=http://localhost:3000 ADMIN_URL=http://localhost:3002 npm run smoke:ui
```

To deliberately run without the test-mode header:

```bash
SMOKE_TEST_MODE=false npm run smoke:api
```
