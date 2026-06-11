# Codex Override Rules for `uipath-coded-apps`

Use these rules only to adapt the upstream `uipath-coded-apps` skill to Codex. Outside these overrides, follow `uipath-coded-apps` exactly.

## User input

- If the upstream skill says to use `AskUserQuestion` or any Claude-specific question tool, ask the user directly in normal Codex chat instead.
- Do not skip required questions for app type, environment, app name, client ID, org, tenant, folder, or any other input the upstream skill requires.

## Local run

- When the local dev server is run for verification, use `http://localhost:5173`.
- Do not prefer `127.0.0.1` for local verification, because that can cause IPv6 or redirect issues in this flow.

## Login and cloud preflight

- Always run `uip login status --output json` before any cloud command if the upstream skill requires auth.
- If login is missing or invalid, stop and complete the login flow before continuing.

## Deploy command behavior

- For normal deploys, do not add `--version` to `uip codedapp deploy`.
- Only pass `--version` if the user explicitly wants to deploy a specific published version.

## Sites behavior

- `@Sites` is only for app generation and UX shaping in this flow.
- Never fall back to normal Sites hosting for matched UiPath coded-app requests unless the user explicitly asks for dual deployment.
