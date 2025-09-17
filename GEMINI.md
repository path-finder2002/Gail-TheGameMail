# GEMINI.md

## Project Overview

This project, "WarMail: ATK & DEF," is an open-source browser game. The concept is a tower defense game set in an email inbox, where the player has to fight back enemies while handling incoming emails. The game is built with React for the UI, Phaser for the game engine, and TypeScript for the codebase. The architecture is based on a modular structure with separate directories for UI components, Phaser scenes, domain services, shared utilities, and type definitions.

## Building and Running

### Prerequisites

- Node.js and npm

### Installation

```bash
npm install
```

### Development

To run the game in a development environment, use the following command. This will start a Vite dev server.

```bash
npm run dev
```

### Building

To create a production build, use the following command:

```bash
npm run build
```

### Testing

The project uses Vitest for unit tests and Playwright for end-to-end tests.

- **Run all tests:**
  ```bash
  npm run test
  ```
- **Run end-to-end tests:**
  ```bash
  npm run test:e2e
  ```

### Linting and Formatting

The project uses ESLint for linting and Prettier for code formatting.

- **Run linter:**
  ```bash
  npm run lint
  ```
- **Run formatter:**
  ```bash
  npm run format
  ```

## Development Conventions

### Coding Style

- **TypeScript:** Use strict typing and explicit exports.
- **Naming Conventions:**
  - `camelCase` for variables and functions.
  - `PascalCase` for components.
  - `SCREAMING_SNAKE_CASE` for constants.
- **Formatting:** 2-space indentation, arrow functions for small callbacks, and absolute imports rooted at `src/`.

### Testing

- Aim for ≥80% unit test coverage and 100% coverage of critical game loops.
- Unit tests should be named after the subject under test (e.g., `scoreCalculator.test.ts`).
- Playwright tests should be triggered for any gameplay or Supabase integration changes.

### Commits and Pull Requests

- **Commit Messages:** Follow the Conventional Commits specification (e.g., `feat(game): add tutorial scene`).
- **Pull Requests:** Each PR should describe the scope, testing evidence, and linked issues. Include screenshots or GIFs for UI/gameplay changes.
