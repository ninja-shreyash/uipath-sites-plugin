---
name: uipath-coded-sites
description: Use with Sites when a site request must become a UiPath coded app, use `@uipath/uipath-typescript`, create `uipath.json`, or deploy with `uip codedapp`. Trigger on `@Sites` requests mentioning UiPath, coded app, Orchestrator, `uipath-typescript`, `uip codedapp`, or projects that already contain `uipath.json`.
---

# UiPath Coded Sites

Use this skill when the user invokes `@Sites` but the real target is a UiPath coded app instead of normal Sites hosting.

## Routing Rules

- Treat matched UiPath requests as a deployment-target override of normal Sites hosting.
- Use `Sites` for product and UI-building behavior only.
- Do **not** use the `sites-hosting` flow for matched UiPath coded-app requests.
- Use the official `uipath-coded-apps` skill as the source of truth for:
  - `uipath.json`
  - OAuth and auth setup
  - `@uipath/uipath-typescript`
  - local verification
  - `pack -> publish -> deploy`

## Match Conditions

Apply this skill when any of the following are true:

- the user says `@Sites` and mentions `UiPath`
- the user says `@Sites` and mentions `coded app`
- the user says `@Sites` and mentions `Orchestrator`
- the user says `@Sites` and mentions `uip codedapp`
- the project already contains `uipath.json`

Do not use this skill for generic Sites requests like landing pages or normal Cloudflare-hosted internal tools unless the user explicitly wants UiPath coded-app output.

## First-Run Bootstrap

- This plugin expects a `SessionStart` hook to ensure `@uipath/cli` is installed globally.
- If the official UiPath Codex skills are missing, run:

```bash
uip skills install --agent codex
```

- After installing skills, tell the user to start a new thread before relying on `uipath-coded-apps`.
- Do not emulate the full coded-app flow inside this plugin when the official skill is unavailable.

## Project Contract

For matched requests, shape the Sites output as a UiPath-coded-app-compatible project:

- static Vite + React app
- `base: './'`
- `@uipath/uipath-typescript`
- `uipath.json` at project root
- `getAppBase()` for router basename when a client router is present
- no `.openai/hosting.json` unless the user explicitly asks for dual deployment

Follow the official `uipath-coded-apps` skill's requirements for `uipath.json`, scopes, auth, SDK usage, build, and deploy. Read [references/uipath-typescript.md](references/uipath-typescript.md) for the Sites-specific compatibility rules that differ from normal Sites output.
