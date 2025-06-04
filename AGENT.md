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

# Agentic Orchestration & Compliance Documentation

## Overview
The agentic subsystem provides orchestration, compliance, and security auditing for the platform. It is currently a stub for future extension, with infrastructure in place for workflows, code analysis, and compliance checks.

## Components
- **workflow.py**: LangGraph-based workflow for analyzing requests and selecting tools (stub).
- **mcp_protocol.yaml**: Defines available tools and endpoints for code analysis (stub).
- **SecurityAgent.js**: Configures a security agent for HIPAA/SOC2 compliance analysis (stub).
- **compliance_middleware.py**: Middleware for enforcing HIPAA compliance in agent workflows (stub).

## How It Works (Future)
- The agent will receive context and user info, analyze requests, and select tools for further processing.
- Security agent can be extended to perform static code analysis, audit trails, and compliance checks.

## Extending
- Implement real workflows and compliance checks.
- Integrate with external code analysis or compliance tools via MCP protocol.
