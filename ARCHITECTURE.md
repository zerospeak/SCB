# System Architecture

> HealthGuard Solutions is a modular, containerized insurance fraud detection platform designed for extensibility, compliance, and real-time analytics. The architecture supports rapid development, robust security, and future scalability.

---

## Key Features

- **Authentication & Authorization:**
  - ASP.NET Core Identity and JWT authentication for all APIs
  - No self-signup; all users are provisioned/admin-created
  - Dev/test admin credentials: `admin` / `Admin!234`
- **Professional Frontends:**
  - Blazor, Angular, and React UIs
  - Responsive, fintech-grade design with Material/Bootstrap
  - JWT-secured API calls and SPA routing via nginx
- **API (.NET 8, WebAPI, EF Core):**
  - REST endpoints for claim analysis and history
  - Swagger UI for API exploration
  - CORS enabled for all frontends
  - EF Core with SQL Server, auto-migrations, persistent CRUD
- **ETL Service:**
  - PowerShell-based, containerized for future batch processing and reporting
- **Database:**
  - SQL Server (Azure SQL Edge) in Docker, persistent volume `sql_data`
  - Schema managed by EF Core migrations
- **DevOps:**
  - `run-dev.ps1` automates build, migration, orchestration, and logs
  - Postman collection for automated API testing
- **Deployment:**
  - Docker Compose for local dev, Kubernetes manifests for future production

---

## Component Overview

1. **Backend API (.NET 8)**
   - RESTful endpoints for claims, analytics, and authentication
   - Machine learning service integration (stub for MVP)
   - Robust validation and error handling
2. **Frontend (Blazor, Angular, React)**
   - Interactive dashboards, claims CRUD, and analytics
   - SPA routing and secure API integration
   - Playwright e2e tests for user flows
3. **Database (SQL Server 2019/Azure SQL Edge)**
   - Persistent storage for claims and risk scores
   - Schema and indexes managed by EF Core
4. **ETL Service (PowerShell)**
   - Stub for future data import/export and reporting
5. **Agentic Orchestration (Python, JS, YAML)**
   - Stub for future compliance, code analysis, and workflow automation
6. **Deployment**
   - Docker Compose for dev, Kubernetes for production scaling

---

## Data Flow

1. Claims are submitted via the frontend.
2. Backend scores the claim and stores it in in-memory or persistent history.
3. Results are displayed live in the frontend and claim history table.

---

## Security & Compliance

- HIPAA policy enforcement and audit trail stubs in backend and agent
- Ready for future authentication, encryption, and compliance modules

---

## Extensibility

- Each service is containerized and independently replaceable or extendable
- Designed for integration with analytics, ML, or compliance modules

---

For more details, see the respective documentation files for each component and the [README.md](./README.md) for setup and usage instructions.
