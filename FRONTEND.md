# HealthGuard Frontend Development

## Apps
- **ReactFrontend**: Modern React app with Material UI, cache-busting, and professional UX.
- **AngularFrontend**: Angular app with Angular Material, proxy config, and `/health` route for dev status.
- **Frontend (Blazor)**: Blazor WebAssembly app with `/health` page and .env.example for config.

## Dev Best Practices
- Use `.env.example` or `environment.example.ts` for config.
- Use proxy configs for API calls in dev.
- Use lint/format scripts and pre-commit hooks (Husky recommended).
- Use Material UI/Angular Material for consistent, professional UI.
- All frontends have `/health` or equivalent for dev status.
- Use version.txt (React) or file hashing (Angular) for cache busting.

## Onboarding
- See each app's README for setup, scripts, and health check info.
