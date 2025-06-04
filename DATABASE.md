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

# Database Documentation

**Last Updated: 2024-06-03**

> This documentation reflects the current state of the application, scripts, and architecture as of the above date.

## Application Current State (as of latest update)
- **Status:** SQL Server (Azure SQL Edge) running in Docker on port 1433
- **Persistence:** Data is stored in Docker volume `sql_data` (not deleted on container restart)
- **Schema:** Managed by EF Core migrations; Claims table is created automatically
- **No repeated re-initialization:** Data persists unless volume is manually removed
- **Build/Run:** Included in run-dev.ps1; auto-initialized
- **Common Issue:** If data is lost on restart, ensure `docker compose down` is used (not `-v`)

## Overview
The system uses SQL Server 2019 for persistent storage of insurance claims and risk scores. The schema is managed by EF Core and optimized for analytics and fraud detection queries.

## Schema
### Claims Table
- **Id**: INT, Primary Key, Identity
- **ProviderID**: NVARCHAR(50)
- **MemberSSN**: NVARCHAR(20)
- **PaidAmount**: DECIMAL(18,2)
- **IsFraud**: BIT
- **Risk**: FLOAT
- **Timestamp**: DATETIME

## Indexes
- Managed by EF Core; add as needed for analytics and reporting.

## Migrations
- The schema is created and updated via EF Core migrations on startup.

## Extending
- Add more tables for audit trails, users, or additional analytics as needed.
- Add additional indexes for performance as needed.
