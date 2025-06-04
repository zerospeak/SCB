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

# Demo Instructions

**Last Updated: 2024-06-03**

> This documentation reflects the current state of the application, scripts, and architecture as of the above date.

## For End Users (Demo Walkthrough)

- **Login credentials for demo:**
  - Username: `admin`
  - Password: `Admin!234`

1. **Start the Demo**
   - Run the demo script:
     ```
     pwsh c:\temp\BCS\run-demo.ps1
     ```
   - Wait for the browser to open at [http://localhost:5000](http://localhost:5000)

2. **Submit a Claim**
   - Click "Submit Claim" in the navigation.
   - Fill in Provider ID, Member SSN, and Paid Amount.
   - Click "Submit" and see the risk score instantly.

3. **View Analytics**
   - Click "Risk Dashboard" to see the risk distribution table.
   - Click "Generate Demo Claims" to populate the dashboard with sample data.

4. **View Claim History**
   - Click "Claim History" to see the last 20 submitted/demo claims and their risk scores.

5. **Reset Demo Data**
   - (Optional) Restart the demo to clear all in-memory data.

---

## For IT Director / Tech Lead (Setup, Test, and Evaluate)

1. **Clone the Repository**
   - Ensure Docker Desktop and .NET 8 SDK are installed.
   - Clone the project to your local machine.

2. **Run Dev/Test Script**
   - In the project root, run:
     ```
     pwsh c:\temp\BCS\run-dev.ps1
     ```
   - This will clean, build, test, and start all services.

3. **Run Demo Script**
   - For a demo with auto-generated data, run:
     ```
     pwsh c:\temp\BCS\run-demo.ps1
     ```

4. **Run Automated UI Test (Optional)**
   - Install Playwright if not already installed:
     ```
     npm install -g playwright
     playwright install
     ```
   - Run the UI test:
     ```
     npx playwright test Frontend/Tests/PlaywrightDemo.spec.ts
     ```

5. **Review Documentation**
   - See README.md, ARCHITECTURE.md, and CHANGELOG.md for full details.

6. **Evaluate**
   - All data is in-memory for demo/dev.
   - All warnings and errors are resolved.
   - The system is ready for feedback, extension, or pilot/production hardening.

---

## Troubleshooting SPA Routing
- All frontends are served via nginx with SPA routing enabled (`try_files $uri $uri/ /index.html;`).
- Direct navigation or refresh on any client-side route (e.g., `/login`, `/claims/123`) should work without 404 errors.
- If you see a 404 on a client-side route, ensure your containers are up-to-date and rebuilt with the latest configuration.
