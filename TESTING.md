# HealthGuard Testing Guide

## Unit Tests
- **API:**
  - Run with `dotnet test` in `Api.Tests`.
  - Uses in-memory DB for fast, isolated tests.
- **ReactFrontend:**
  - Run with `npm test`.
  - Uses Jest/React Testing Library.
- **AngularFrontend:**
  - Run with `ng test`.
  - Uses Jasmine/Karma.
- **Blazor/Frontend:**
  - Add and run with `dotnet test` if test project exists.

## Integration/E2E Tests
- **API:**
  - Use real SQL Server (Docker) for integration tests.
- **React/Angular:**
  - Use Playwright for E2E: `npx playwright test` (React), `ng e2e` (Angular).
- **Blazor:**
  - Add E2E tests if needed.

## Best Practices
- Use in-memory DB for unit tests, real DB for integration/E2E.
- Run all tests before merging or deploying.
- Add tests for new features and bug fixes.
- Use CI to automate test runs on every PR/commit.
