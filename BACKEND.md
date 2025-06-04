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

# Backend API Documentation

**Last Updated: 2024-06-03**

> This documentation reflects the current state of the application, scripts, and architecture as of the above date.

## Application Current State (as of latest update)
- **Authentication & Authorization:**
  - ASP.NET Core Identity and JWT authentication are fully integrated.
  - Admin credentials for dev/testing: **admin / Admin!234**
  - No self-signup; all users are provisioned/admin-created.
- **Status:** Running in Docker on port 5000
- **Swagger UI:** Always enabled at http://localhost:5000/swagger
- **CORS:** Enabled for all frontends
- **Persistent SQL Data:** Enabled (volume `sql_data`)
- **ASPNETCORE_ENVIRONMENT:** Development (for dev features)
- **EF Core:** All CRUD operations for Claims are persistent; auto-migrations on startup
- **Build/Run:** Included in run-dev.ps1; auto-built and served

## Endpoints

### POST /login
- **Description:** Authenticate and get a JWT token (use for all subsequent requests)
- **Request Body:**
  ```json
  {
    "username": "admin",
    "password": "Admin!234"
  }
  ```
- **Response:**
  ```json
  {
    "token": "<JWT>"
  }
  ```

### POST /api/claims
### GET /api/claims/history
### GET /api/claims/{id}
### PUT /api/claims/{id}
### DELETE /api/claims/{id}
### POST /api/claims/generate-demo-claims

(See README.md and Postman collection for full details.)
