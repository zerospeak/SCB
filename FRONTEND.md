# Frontend Documentation (Blazor, Angular, React)

**Last Updated: 2024-06-03**

> This documentation reflects the current state of the application, scripts, and architecture as of the above date.

## Application Current State (as of latest update)
- **Authentication:**
  - All frontends use JWT authentication and secure API calls.
  - Login forms are professional, responsive, and fintech-grade.
- **Blazor WebAssembly:**
  - Running in Docker/nginx on port 5002
  - Professional, responsive, and fintech-grade UI/UX
- **Angular (Angular Material):**
  - Running in Docker/nginx on port 5003
  - Professional, responsive, and fintech-grade UI/UX
- **React (Material-UI, TypeScript):**
  - Running in Docker/nginx on port 5004
  - Professional, responsive, and fintech-grade UI/UX
- **Playwright e2e Tests:**
  - All user flows (CRUD for Claims) are covered for each frontend
  - Test files are located in each frontend's test or claims directory
- **Unified Orchestration:**
  - All frontends are built and served as part of the Docker Compose setup
  - Scripts (`run-dev.ps1`, `run-demo.ps1`) orchestrate build, run, and test for all frontends

## How It Works
- All frontends communicate with the backend API for CRUD operations on claims.
- Each frontend provides a professional, financial-grade UI/UX for claims management.
- Playwright e2e tests validate all user flows (list, create, edit, view, delete claims).

## SPA Routing with nginx
- All frontends are served via nginx with SPA routing enabled.
- nginx is configured with `try_files $uri $uri/ /index.html;` for the root location, so direct navigation or refresh on any client-side route (e.g., `/login`, `/claims/123`) will load the SPA and not return a 404.
- This is essential for Angular, React, and Blazor frontends using client-side routing.

## Running the Frontends
- All frontends are built and served as part of the Docker Compose setup.
- Accessible at:
  - Blazor: http://localhost:5002
  - Angular: http://localhost:5003
  - React: http://localhost:5004
- Run `powershell ./setup-dev.ps1` to ensure all dependencies/configs are present.
- Run `powershell ./run-dev.ps1` to build, start, and orchestrate all services (auto-checks container health).
- Run Playwright e2e tests in each frontend directory after services are up.

## See README.md and PROJECT_SUMMARY.md for more details on architecture, scripts, and developer tips.
