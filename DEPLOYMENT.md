# HealthGuard Deployment Guide

## Local Development

1. **Copy .env.example to .env** in each app/service and fill in local values.
2. **Start SQL Server** (Docker recommended):
   ```
   docker-compose up sql-server
   ```
3. **Reset/seed dev DB:**
   ```
   cd Api
   pwsh -File reset-dev-db.ps1
   ```
4. **Start API:**
   ```
   cd Api
   dotnet run
   ```
5. **Start React Frontend:**
   ```
   cd ReactFrontend
   npm install
   npm start
   ```
6. **Start Angular Frontend:**
   ```
   cd AngularFrontend
   npm install
   npm start -- --proxy-config proxy.conf.json
   ```
7. **Start Blazor/Frontend:**
   ```
   cd Frontend
   dotnet run
   ```
8. **Start ETL/Agent as needed.**

## Full Stack with Docker Compose
- Use `docker-compose up` (with `docker-compose.override.yml` for local dev) to start all services.

## Health Checks
- API: [http://localhost:5000/health](http://localhost:5000/health)
- React: [http://localhost:5002](http://localhost:5002)
- Angular: [http://localhost:5003/health](http://localhost:5003/health)
- Blazor: [http://localhost:5004/health](http://localhost:5004/health)
- ETL/Agent: `/health` endpoints

## Production
- Use environment variables for all secrets and URLs.
- Use HTTPS for all services.
- Use Docker Compose or Kubernetes for orchestration.
- Run database migrations before starting API in prod.
