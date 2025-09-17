# Repository Guidelines

## Project Structure & Module Organization
Source lives in `src/`, split into React UI components, Phaser `scenes/`, domain `services/`, shared `utils/`, and typed contracts under `types/`. Custom hooks sit in `hooks/`. Tests mirror production code inside `tests/unit` and `tests/e2e`, with fixtures in `tests/fixtures`. Reference `docs/ARCHITECTURE.md` and `docs/ASSETS.md` for scene flow, data contracts, and art pipelines.

## Build, Test, and Development Commands
Install once with `npm install`. Run the playground with `npm run dev` (Vite dev server) and create a production bundle via `npm run build`. Keep quality gates green using `npm run lint` (ESLint) and `npm run format` (Prettier). Before pushing, execute `npm run test` for Vitest and `npm run test:e2e` for Playwright; add `:watch`, `:coverage`, or `:ui` suffixes as needed.

## Coding Style & Naming Conventions
TypeScript is the default; maintain strict typing and explicit exports. Follow camelCase for variables/functions, PascalCase for components, SCREAMING_SNAKE_CASE for constants, and align filenames accordingly. Indent with two spaces, prefer arrow functions for small callbacks, and use absolute imports rooted at `src/`. Run Prettier and ESLint locally; configs live in the repo and should not be bypassed.

## Testing Guidelines
Aim for ≥80% unit coverage and 100% coverage of critical game loops. Name unit tests after the subject under test (e.g., `scoreCalculator.test.ts`) and co-locate helpers in `tests/fixtures`. Trigger Playwright suites for any gameplay or Supabase integration change, and capture flaky cases before merging. CI replicates `npm run test:coverage` and `npm run test:e2e`, so ensure both pass locally.

## Commit & Pull Request Guidelines
Adopt Conventional Commits: `feat(game): add tutorial scene`, `fix(score): clamp combo multiplier`, etc. Each PR should describe scope, testing evidence, and linked issues; include screenshots or gifs for UI/gameplay tweaks. Keep PRs focused—split follow-up tasks rather than batching divergent changes. Drafts are welcome while gathering feedback, but convert to ready-for-review only after lint, format, and tests succeed.

## Security & Configuration Tips
Store Supabase keys in `.env.local` and never commit secrets. When testing auth flows, use dedicated test accounts documented in `docs/SECURITY.md`. Verify RLS policies before deploying new score or profile endpoints, and flag any telemetry additions in the PR checklist.
