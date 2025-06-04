# HealthGuard Architecture

## High-Level Diagram

```
+-------------------+      +-------------------+      +-------------------+
|   ReactFrontend   |<---->|      API          |<---->|    SQL Server     |
+-------------------+      +-------------------+      +-------------------+
        |                        ^   ^
+-------------------+            |   |
| AngularFrontend   |<-----------+   |
+-------------------+                |
        |                            |
+-------------------+                |
|   BlazorFrontend  |<---------------+
+-------------------+                |
        |                            |
+-------------------+                |
|      ETL          |----------------+
+-------------------+                |
        |                            |
+-------------------+                |
|     Agent         |----------------+
+-------------------+
```

## Component Relationships
- **Frontends** (React, Angular, Blazor) communicate with the API via REST endpoints.
- **API** handles business logic, authentication, and database access.
- **SQL Server** stores claims and user data, managed via EF Core migrations.
- **ETL** and **Agent** services interact with the API for data processing and security.

## Dev Environment
- All services expose `/health` endpoints.
- All frontends use environment/proxy config for API URLs.
- Docker Compose enables full-stack local dev.

## Health Checks
- API: `/health`, `/agent-health`
- React: `/version.txt` (cache busting)
- Angular: `/health`
- Blazor: `/health`
- ETL/Agent: `/health`
