# AngularFrontend Dev Onboarding

## Environment Setup
- Copy `src/environments/environment.example.ts` to `src/environments/environment.ts` and set your API URL.
- Use `proxy.conf.json` for local API proxying to avoid CORS.

## Scripts
- `npm run lint` — Lint code
- `npm run format` — Format code with Prettier
- `npm start` — Start dev server with hot reload
- `npm run build` — Production build

## Health Check
- Visit `/health` route in the app for a simple health status page.

## Best Practices
- Use Angular Material for consistent UI.
- Use environment files for all API URLs and secrets.
- Use proxy config for API calls in dev.
- Use lint/format scripts and pre-commit hooks (Husky recommended).
