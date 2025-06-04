# HealthGuard Solutions: Insurance Fraud Detection System

> Comprehensive platform for insurance fraud detection, featuring secure authentication, robust APIs, professional frontends, and automated ETL and deployment workflows.

## Application State (as of 2024-06-03)

- **Authentication & Authorization:**
  - ASP.NET Core Identity and JWT authentication fully integrated
  - All endpoints protected by JWT in production; no self-signup
  - Dev/test admin credentials: `admin` / `Admin!234` (see Postman collection)
- **API (.NET 8, WebAPI, EF Core):**
  - Runs in Docker on port 5000
  - Swagger UI: [http://localhost:5000/swagger](http://localhost:5000/swagger)
  - CORS enabled for all frontends
  - EF Core with SQL Server, auto-migrations on startup
  - Persistent CRUD for Claims
- **Frontend (Blazor, Angular, React):**
  - Professional, responsive, fintech-grade UIs
  - Login, claims list, and forms with Material/Bootstrap, validation, and feedback
  - JWT-secured API calls
  - Served via nginx with SPA routing (`try_files $uri $uri/ /index.html;`)
- **ETL Service:**
  - Runs in Docker, stays alive for dev/demo
- **SQL Server (Azure SQL Edge):**
  - Runs in Docker on port 1433
  - Data persisted in Docker volume `sql_data`
- **Dev Script:**
  - `run-dev.ps1` automates clean, restore, build, migration check, container orchestration, and logs
- **Postman Collection:**
  - `HealthGuard.postman_collection.json` for automated API testing with JWT
- **Documentation:**
  - All .md files reflect current state, troubleshooting, and run instructions

---

## Quick Start

1. Open a terminal in `c:\temp\BCS`.
2. Run:
   ```powershell
   ./setup-dev.ps1
   ./run-dev.ps1
   ```
   - Installs dependencies, cleans, restores, builds, checks migrations, starts containers, and tails logs.
   - All frontends auto-configure API URLs for Docker/local dev.

---

## Additional Resources

- See [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md) for step-by-step history, lessons learned, and developer tips.
- For demo instructions, troubleshooting, and deployment, refer to the respective `.md` files in this repository.
