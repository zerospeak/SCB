- **Authentication & Authorization:**
  - ASP.NET Core Identity and JWT authentication are fully integrated.
  - All endpoints are protected by JWT in production; no self-signup.
  - Admin credentials for dev/testing: **admin / Admin!234** (see Postman collection for usage).
- **API (.NET 8, WebAPI, EF Core):**
  - Running in Docker on port 5000
  - Swagger UI available at http://localhost:5000/swagger
  - CORS enabled for all frontends
  - EF Core with SQL Server, auto-migrations on startup
  - All CRUD operations for Claims are persistent
- **Frontend (Blazor, Angular, React):**
  - All frontends are professional, responsive, and fintech-grade
  - Login, claims list, and forms use Material/Bootstrap, validation, and clear feedback
  - All frontends use JWT authentication and secure API calls
  - All frontends are served via nginx with SPA routing enabled (nginx uses `try_files $uri $uri/ /index.html;`), so direct navigation to any client-side route (e.g., `/login`) works without 404 errors.
- **ETL Service:**
  - Running in Docker, stays alive for dev/demo
- **SQL Server (Azure SQL Edge):**
  - Running in Docker on port 1433
  - Data persisted in Docker volume `sql_data`
- **Dev Script:**
  - `run-dev.ps1` automates clean, restore, build, migration check, container orchestration, and logs
- **Postman Collection:**
  - `HealthGuard.postman_collection.json` for automated API testing with JWT
- **Documentation:**
  - All .md files reflect current state, troubleshooting, and run instructions

# Deployment Documentation

**Last Updated: 2024-06-03**

> This documentation reflects the current state of the application, scripts, and architecture as of the above date.

## Application Current State (as of latest update)
- **Authentication & Authorization:**
  - ASP.NET Core Identity and JWT authentication are fully integrated.
  - Admin credentials for dev/testing: **admin / Admin!234**
  - No self-signup; all users are provisioned/admin-created.
- **All services are containerized and orchestrated via Docker Compose**
- **Persistent SQL Server data enabled (volume `sql_data`); not deleted on restart**
- **Frontend served by nginx on ports 5002/5003/5004 (Blazor/Angular/React)**
  - nginx is configured for SPA routing (`try_files $uri $uri/ /index.html;`), so direct navigation to any client-side route works without 404 errors.
- **API (with Swagger UI) on port 5000, CORS enabled, dev mode, EF Core auto-migrations**
- **ETL service runs and stays alive for dev/demo**
- **run-dev.ps1 script automates clean build, restore, migration check, container orchestration, and logs**
- **Postman collection for automated API testing**

## Local Development (Docker Compose)
1. Build and start all services:
   ```
   powershell ./run-dev.ps1
   ```
2. Access the frontend at [http://localhost:5002](http://localhost:5002)
3. The backend API is available at [http://localhost:5000/api/claims](http://localhost:5000/api/claims)
4. SQL Server is exposed on port 1433 (default SA password: `Your_password123`)

## Production Deployment (Kubernetes)
- Use `k8s-deployment.yaml` for deploying the agentic service.
- Extend with additional manifests for other services as needed.
- Configure secrets, persistent storage, and ingress for production (commented out in MVP).

## Environment Variables
- Set `API_KEY` for load testing and secure API access.
- Update database connection strings as needed for your environment.

## Notes
- All services are containerized and can be scaled or replaced independently.
- For real deployments, update secrets and credentials before going live.
- The MVP is fully functional for dev; production features are stubbed or commented for future use.
