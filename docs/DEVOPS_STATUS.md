# DevOps Status

This file explains what exists today and what still needs production setup.

## Ready

- Dockerfile for each service: frontend, admin, backend, AI.
- Local Docker Compose stack in `docker-compose.dev.yml`.
- Local Postgres container with persistent volume.
- API smoke tests in `scripts/smoke-api.mjs`.
- UI smoke tests in `scripts/smoke-ui.mjs`.
- GitHub Actions CI for frontend/admin, backend, and AI.
- Basic GitHub Actions CD workflow through SSH.
- Cloudinary integration for listing image upload.
- Email provider abstraction with console, SMTP, and Resend.

## Added For Production Organization

- `docker-compose.prod.yml` for production-style service layout.
- `.env.production.example` for server-only secrets and domain settings.
- Nginx template in `nginx/templates/aqarx.conf.template`.
- API rate limiting at Nginx level.
- Automatic Postgres backup service in production compose.
- Manual backup and restore scripts.
- Deploy script that uses `up -d --remove-orphans` instead of full `down`.
- Server bootstrap script for Docker, Git, SSH firewall basics.

## Partial

- CD exists, but it needs GitHub secrets and real server `.env.production`.
- HTTPS template exists, but certificates must be issued on the server.
- Monitoring is still mostly Docker logs and app dashboards.
- Backups exist locally/on-server; S3 backup upload is not wired yet.

## Missing Later

- Terraform or repeatable AWS infrastructure as code.
- Sentry or another error tracking service.
- Prometheus/Grafana or a hosted metrics system.
- Centralized logs.
- S3 backup upload and lifecycle policy.
- Blue/green or zero-downtime deployment strategy.
- Production-grade secret manager such as AWS Secrets Manager.