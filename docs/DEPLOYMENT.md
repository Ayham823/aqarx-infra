# Deployment Guide

## 1. Server Setup

On a fresh Ubuntu EC2 server:

```bash
git clone <your-infra-repo-url> ~/aqarx-infra
cd ~/aqarx-infra
bash scripts/server-bootstrap.sh
```

Log out and back in after bootstrap so Docker permissions apply.

## 2. Production Environment

Create production env on the server only:

```bash
cd ~/aqarx-infra
cp .env.production.example .env.production
nano .env.production
```

Fill real values for:

- domains
- database password
- JWT secret
- Resend
- Cloudinary
- PostHog
- Google Analytics
- OpenAI if using real AI provider

Never commit `.env.production`.

## 3. DNS

Point DNS records to the EC2 public IP:

```text
yourdomain.com        A    <EC2_PUBLIC_IP>
admin.yourdomain.com  A    <EC2_PUBLIC_IP>
api.yourdomain.com    A    <EC2_PUBLIC_IP>
```

## 4. First Deploy

The default Nginx template is HTTP-only so the first deploy can start before SSL exists:

```bash
cd ~/aqarx-infra
bash scripts/deploy.sh
```

## 5. HTTPS / Certbot

The Nginx template expects certificates under:

```text
/etc/letsencrypt/live/<PUBLIC_DOMAIN>/
```

Issue certificates after DNS points to the server. One simple approach:

```bash
docker compose -f docker-compose.prod.yml --env-file .env.production run --rm certbot certonly \
  --webroot \
  --webroot-path /var/www/certbot \
  --email "$LETSENCRYPT_EMAIL" \
  --agree-tos \
  --no-eff-email \
  -d "$PUBLIC_DOMAIN" \
  -d "$ADMIN_DOMAIN" \
  -d "$API_DOMAIN"
```

After certificates are created, enable the HTTPS template:

```bash
cp nginx/ssl-templates/qivro.conf.template nginx/templates/qivro.conf.template
rm -f nginx/templates/qivro-http.conf.template
docker compose -f docker-compose.prod.yml --env-file .env.production restart nginx
```

## 6. Manual Update

```bash
cd ~/aqarx-infra
git pull --ff-only
bash scripts/deploy.sh
```

## 7. Auto Deploy

Set these GitHub repository secrets in the infra repo:

```text
EC2_HOST
EC2_USER
SSH_KEY
DEPLOY_PATH
```

Then pushing to `main` triggers deploy.

## 8. Backups

Manual backup:

```bash
cd ~/aqarx-infra
bash scripts/backup-postgres.sh
```

Restore needs explicit confirmation:

```bash
CONFIRM_RESTORE=yes bash scripts/restore-postgres.sh backups/qivro-YYYYMMDD-HHMMSS.sql.gz
```

## 9. Logs

```bash
docker compose -f docker-compose.prod.yml --env-file .env.production logs -f backend
docker compose -f docker-compose.prod.yml --env-file .env.production logs -f frontend
docker compose -f docker-compose.prod.yml --env-file .env.production logs -f admin
docker compose -f docker-compose.prod.yml --env-file .env.production logs -f ai
docker compose -f docker-compose.prod.yml --env-file .env.production logs -f nginx
```