# Testing Documentation

## Overview
The project includes comprehensive tests for backend, frontend, database, ETL, agent, and end-to-end flows. All code warnings and errors have been resolved for a clean test experience.

## Backend API Tests
- Located in `api.Tests/` (xUnit).
- Test ClaimsController and ML service logic.
- Run with `dotnet test` in the `api.Tests` directory.

## Frontend Tests
- Playwright UI test scaffolded in `frontend/Tests/PlaywrightDemo.spec.ts`.
- Run with Playwright CLI after starting the app.
- Test claim submission, error handling, and history display via the UI.
- Manual testing also recommended for new features.

## Database Tests
- `db/test_db.sql` verifies Claims table and index.
- Run in SQL Server Management Studio or via container shell.

## ETL & Agent Tests
- `etl/test_etl.ps1` and `agent/test_agent.py` are smoke tests for container startup.

## End-to-End (E2E) Test
- `tests/e2e_claim_submission.py` submits a claim to the API and checks the response.
- Run with `python tests/e2e_claim_submission.py` (requires backend running).

## Security & Compliance
- `tests/test_hipaa_compliance.py` checks for encryption and vulnerabilities in code.

## Load Testing
- `tests/load-test.js` (k6) simulates high load on the API.
- Run with `k6 run tests/load-test.js` (requires k6 installed).
