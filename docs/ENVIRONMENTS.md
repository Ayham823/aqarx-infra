# Environment Strategy

Qivro uses three environments. The codebase should stay the same, but data, domains, secrets, and deployment rules must be separate.

## 1. Local

Purpose: development on your machine.

URLs:

```text
http://localhost:3000      public UI
http://localhost:3002      admin UI
http://localhost:3001/api  backend API
http://localhost:8000      AI service
```

Data:

```text
Local Docker Postgres only
Do not connect local development to production DB
```

Env template:

```text
.env.local.example
```

## 2. Staging

Purpose: test close to real production before users see changes.

Domains:

```text
staging.qivro.io
admin-staging.qivro.io
api-staging.qivro.io
```

Data:

```text
Separate staging database
Separate staging Cloudinary folder
Email provider can stay console at first
AI provider can stay mock at first
```

Env template on the server:

```text
.env.staging
```

Start from:

```bash
cp .env.staging.example .env.staging
```

Deploy:

```bash
DEPLOY_ENV=staging bash scripts/deploy.sh
```

## 3. Production

Purpose: real users and real data.

Domains:

```text
qivro.io
www.qivro.io
admin.qivro.io
api.qivro.io
```

Data:

```text
Separate production database
Real email domain
Production Cloudinary folder
Production analytics keys
Daily backups required
```

Env template on the server:

```text
.env.production
```

Start from:

```bash
cp .env.production.example .env.production
```

Deploy:

```bash
DEPLOY_ENV=production bash scripts/deploy.sh
```

## GitHub Actions Deploy

Deploy is manual now. It no longer runs automatically on every push.

Go to:

```text
GitHub repo -> Actions -> Deploy Qivro -> Run workflow
```

Choose:

```text
staging
production
```

Required GitHub secrets for each environment:

```text
EC2_HOST
EC2_USER
SSH_KEY
DEPLOY_PATH
```

Recommended setup:

```text
GitHub Environments:
- staging
- production
```

Use different secrets per environment if staging and production use different servers.

## Current Recommendation

Use your EC2 as staging first:

```text
staging.qivro.io
admin-staging.qivro.io
api-staging.qivro.io
```

After staging works with SSL, uploads, login, email, admin, and smoke tests, create production.

Do not point real users to production before backups and monitoring are checked.