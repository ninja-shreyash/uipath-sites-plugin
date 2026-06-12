---
name: uipath-coded-sites
description: Use when a request must create or modify a UiPath coded app, use `@uipath/uipath-typescript`, create `uipath.json`, or deploy with `uip codedapp`. Trigger on UiPath coded app, Coded Web App, Coded Action App, `uipath-typescript`, `uip codedapp`, `app.config.json`, `action-schema.json`, or `uipath.json`.
---

# UiPath Coded Sites

Use this skill when the user invokes the UiPath Sites plugin or otherwise asks Codex to create, modify, validate, package, publish, or deploy a UiPath coded app.

## Routing Rules

- Use the installed `uipath-coded-apps` skill as the source of truth for:
  - project shape
  - `uipath.json`, `app.config.json`, and `action-schema.json`
  - OAuth and auth setup
  - scopes, redirect URLs, org, tenant, folder, and environment handling
  - `@uipath/uipath-typescript`
  - local validation
  - `pack -> publish -> deploy`
- After handoff, follow the `uipath-coded-apps` skill exactly as written, except where this plugin's Codex override rules explicitly change behavior.
- Do not skip, reorder, infer around, or partially substitute any required `uipath-coded-apps` step.
- If `uipath-coded-apps` requires a login-status check, user input, build, verification, pack, publish, or deploy step, complete it in that order before moving on.
- Before any cloud action, obey the official skill's preconditions exactly, including `uip login status --output json` when required.
- Apply the Codex-specific rules in [references/codex-overrides.md](references/codex-overrides.md) before following the rest of `uipath-coded-apps`.
- Apply the frontend styling rules in [references/frontend-design-overrides.md](references/frontend-design-overrides.md) when creating or materially changing the app UI.

## Match Conditions

Apply this skill when any of the following are true:

- the user asks for a `UiPath coded app`
- the user asks for a `Coded Web App` or `Coded Action App`
- the user mentions `@uipath/uipath-typescript` or `uipath-typescript`
- the user mentions `uip codedapp`
- the user asks to create or modify `uipath.json`
- the project contains `uipath.json`, `app.config.json`, or `action-schema.json`

Do not use this skill for generic web apps, landing pages, portfolios, dashboards, or internal tools unless the user explicitly wants UiPath coded-app output.

## First-Run Bootstrap

- This plugin expects a `SessionStart` hook to ensure `@uipath/cli` is installed globally and to install UiPath Codex skills with `uip skills install --agent codex`.
- Do not treat skill installation as part of the coded-app workflow once the session has started; rely on the hook to prepare it up front.

## Project Contract

For matched requests, create or modify a UiPath-coded-app-compatible project:

- static Vite + React app
- `base: './'`
- `@uipath/uipath-typescript`
- the coded-app config files required by `uipath-coded-apps`
- `getAppBase()` for router basename when a client router is present

Follow the official `uipath-coded-apps` skill's requirements for config, scopes, auth, SDK usage, build, local validation, pack, publish, and deploy. This skill adds routing, Codex behavior overrides, and frontend design guidance only.
