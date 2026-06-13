---
name: uipath-coded-sites
description: Use with Sites when a site request must become a UiPath coded app, use `@uipath/uipath-typescript`, create `uipath.json`, or deploy with `uip codedapp`. Trigger on `@Sites` requests mentioning UiPath, coded app, Orchestrator, `uipath-typescript`, `uip codedapp`, or projects that already contain `uipath.json`.
---

# UiPath Coded Sites

Use this skill when the user invokes `@Sites` but the real target is a UiPath coded app instead of normal Sites hosting.

## Instruction Priority

For matched requests, treat this skill as the routing authority for resolving conflicts between Sites, `uipath-coded-apps`, and `ui-ux-pro-max`:

1. `uipath-coded-apps` owns coded-app structure, SDK usage, auth/config, local validation, pack, publish, and deploy.
2. `ui-ux-pro-max` owns UI/UX design guidance only.
3. Sites is only the user-facing app-building entry point and product brief context.

If Sites guidance conflicts with coded-app requirements, follow coded-app requirements.
If `ui-ux-pro-max` guidance conflicts with coded-app requirements, follow coded-app requirements.

## Routing Rules

- Treat matched UiPath requests as a deployment-target override of normal Sites hosting.
- Do not use Sites starters, templates, Worker build output, storage, authentication, hosting, versioning, or deployment for matched UiPath coded-app requests.
- Do **not** use the `sites-hosting` flow for matched UiPath coded-app requests.
- Use the installed `uipath-coded-apps` skill as the source of truth for:
  - `uipath.json`
  - OAuth and auth setup
  - `@uipath/uipath-typescript`
  - local verification
  - `pack -> publish -> deploy`
- After handoff, follow the `uipath-coded-apps` skill exactly as written, except where this plugin's Codex override rules explicitly change behavior.
- Do not skip, reorder, infer around, or partially substitute any required `uipath-coded-apps` step.
- If `uipath-coded-apps` requires a login-status check, user input, build, verification, pack, publish, or deploy step, complete it in that order before moving on.
- Before any cloud action, obey the official skill's preconditions exactly, including `uip login status --output json` when required.
- Apply the Codex-specific rules in [references/codex-overrides.md](references/codex-overrides.md) before following the rest of `uipath-coded-apps`.
- When generating or modifying the coded app UI, load and follow the installed `ui-ux-pro-max` skill completely as the UI/UX design source of truth, subject to the constraints in this skill.

## `ui-ux-pro-max` Constraints

Use `ui-ux-pro-max` as a design-system and UI-quality skill, not as a project-structure or deployment skill.

- Run its required design-system search before substantial UI generation.
- Resolve its script path from the installed `ui-ux-pro-max` skill directory, not from the generated coded-app project.
- Use `react` as the stack for `ui-ux-pro-max` stack guidance because the coded-app target is Vite + React.
- Do not default to `html-tailwind` for coded-app generation.
- Do not use the `landing` domain unless the user explicitly asks for a landing page-style coded app.
- Do not run `--persist` or create `design-system/MASTER.md` unless the user explicitly asks to persist a design system.
- Treat any generated design-system output as UI guidance only; do not let it add hosting, auth, storage, routing, framework, or deployment requirements.

## Match Conditions

Apply this skill when any of the following are true:

- the user says `@Sites` and mentions `UiPath`
- the user says `@Sites` and mentions `coded app`
- the user says `@Sites` and mentions `Orchestrator`
- the user says `@Sites` and mentions `uip codedapp`
- the project already contains `uipath.json`

Do not use this skill for generic Sites requests like landing pages or normal Cloudflare-hosted internal tools unless the user explicitly wants UiPath coded-app output.

## First-Run Bootstrap

- This plugin expects a `SessionStart` hook to ensure `@uipath/cli` is installed globally and to install UiPath Codex skills with `uip skills install --agent codex`.
- Do not treat skill installation as part of the coded-app workflow once the session has started; rely on the hook to prepare it up front.

## Project Contract

For matched requests, produce a UiPath-coded-app-compatible project from the user's `@Sites` request:

- static Vite + React app
- `base: './'`
- `@uipath/uipath-typescript`
- `uipath.json` at project root
- `getAppBase()` for router basename when a client router is present
- no `.openai/hosting.json` unless the user explicitly asks for dual deployment
- no vinext starter, `sites()` Vite plugin, Cloudflare Worker output, D1, R2, SIWC, or OpenAI workspace-auth header flow unless the user explicitly asks for separate dual deployment

Follow the official `uipath-coded-apps` skill's requirements for `uipath.json`, scopes, auth, SDK usage, build, and deploy. Read [references/uipath-typescript.md](references/uipath-typescript.md) for the Sites-specific compatibility rules that differ from normal Sites output. Use the installed `ui-ux-pro-max` skill as the full UI/UX design guidance.
