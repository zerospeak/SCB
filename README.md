# HealthGuard Dev Environment (Unified)

## Onboarding Steps

1. **Copy .env.example to .env** in each app and fill in secrets/URLs.
2. **Start SQL Server** (Docker or local) and ensure port 1433 is open.
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
7. **Start Blazor/Frontend as needed.**
8. **Use docker-compose.override.yml** for full-stack local dev if desired.

## Scripts
- `setup-dev.ps1`: Installs all dependencies, sets up config files, builds, and runs a health check.
- `run-demo.ps1`: Resets DB, starts all services, opens frontend for a demo.
- `test-all.ps1`: Resets DB and runs all backend, frontend, and ETL tests.
- `health-check.ps1`: Checks API, frontend, and DB health.
- `lint-all.ps1`: Lints and formats .NET, Angular, and Python code.
- `reset-dev-db.ps1`: Drops, recreates, migrates, and seeds ClaimsDb.
- `npm run lint` / `npm run format`: Lint/format code (React/Angular).
- `npm run build`: Builds frontend and generates version.txt for cache busting.
- Husky pre-commit hook: Lint/format before commit (see .huskyrc.json).

## Health Checks
- API: [http://localhost:5000/health](http://localhost:5000/health)
- Angular: [http://localhost:4200](http://localhost:4200)
- React: [http://localhost:5002](http://localhost:5002)
- ETL/Agent: `/health` endpoints as documented.

## Best Practices
- Use in-memory DB for unit tests, real DB for integration/E2E.
- Never commit secrets to source control.
- Use version.txt for frontend cache busting.
- Use lint/format scripts and pre-commit hooks (Husky recommended).
- Use proxy configs for API calls in dev.
- Keep all onboarding and environment docs up to date.
- For a clean slate DB reset, use `docker-compose down -v` then rerun `run-demo.ps1` or `setup-dev.ps1`.
- If you add new environment/config files, update the corresponding `.sample` file.
