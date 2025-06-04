# HealthGuard Backend Development

## Services
- **Api**: .NET Core Web API with `/health` and `/agent-health` endpoints, EF Core for DB access, and robust dev/test scripts.
- **Etl**: Python-based ETL service with `/health` endpoint and .env.example for config.
- **Agent**: Security/data agent with .env.example and health endpoint.

## Dev Best Practices
- Use `.env.example` for all config and secrets.
- Expose `/health` endpoints for all services.
- Use reset/migration scripts to keep dev DB in sync.
- Use Docker Compose for full-stack local dev.
- Use structured logging and clear error messages.
- Document onboarding and scripts in README.md.

## Onboarding
- See each service's README for setup, scripts, and health check info.
