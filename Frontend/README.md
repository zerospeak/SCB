# Blazor/Frontend Dev Onboarding

## Environment Setup
- Use `appsettings.Development.json` for local API URLs and DB connection strings.
- Document any required environment variables in a `.env.example` if using secrets.

## Scripts
- `dotnet build` — Build the app
- `dotnet run` — Start the dev server
- `dotnet test` — Run tests

## Health Check
- Add a `/health` endpoint to your Blazor/Frontend app for dev status checks (if not present).

## Best Practices
- Use consistent UI components (e.g., MudBlazor or Radzen for Blazor).
- Use environment config for all URLs/secrets.
- Add lint/format scripts if using JS/TS interop.
- Document onboarding and scripts in this README.
