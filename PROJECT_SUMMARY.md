# Project Summary

## Overview
HealthGuard is a full-stack application for managing and analyzing healthcare claims, featuring:
- Multiple frontends (React, Angular, Blazor)
- .NET API backend
- SQL Server database (Dockerized for dev)
- ETL and Agent services for data processing

## Main Components

### Frontends
- **ReactFrontend**: Modern React app with Material UI, cache-busting, and professional UX. Uses `/src/App.tsx` as entry point.
- **AngularFrontend**: Angular app with Angular Material, proxy config, and `/health` route for dev status.
- **Frontend (Blazor)**: Blazor WebAssembly app with `/health` page and .env.example for config.

### Backend Services
- **Api**: .NET Core Web API with `/health` and `/agent-health` endpoints, EF Core for DB access, and robust dev/test scripts.
- **Etl**: Python-based ETL service with `/health` endpoint and .env.example for config.
- **Agent**: Security/data agent with .env.example and health endpoint.

### Database
- **SQL Server**: Dockerized for dev, seeded/reset via `reset-dev-db.ps1`.

## Dev Best Practices
- All apps use `.env.example` for config documentation.
- All services expose `/health` endpoints for monitoring.
- Lint/format/test scripts in all frontends.
- Cache-busting/versioning for React (and Angular via file hashing).
- Docker Compose for full-stack local dev.
- Unified onboarding and health check documentation in README.md.

## Onboarding
See [README.md](README.md) for unified onboarding, scripts, and health check info.
