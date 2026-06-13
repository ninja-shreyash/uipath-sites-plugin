# Codex Override Rules for `uipath-coded-apps`

Use these rules only to adapt the upstream `uipath-coded-apps` skill to Codex. Outside these overrides, follow `uipath-coded-apps` exactly.

## User input

- Collect all required setup inputs at the start of the coded-app workflow, before writing files, building, or launching the local app.
- Do not defer required setup questions until just before local verification or deployment.
- If the upstream skill says to use `AskUserQuestion` or any Claude-specific question tool, ask the user directly in normal Codex chat instead.
- If Codex exposes a structured input tool such as `request_user_input`, prefer that for the initial setup questions.
- If a structured input tool is not available in the current runtime, ask the same questions directly in normal Codex chat and wait for the user's reply before proceeding.
- Do not skip required questions for app type, environment, app name, client ID, org, tenant, folder, or any other input the upstream skill requires.

## Local run

- When the local dev server is run for verification, use `http://localhost:5173`.
- Do not prefer `127.0.0.1` for local verification, because that can cause IPv6 or redirect issues in this flow.

## Login and cloud preflight

- Always run `uip login status --output json` before any cloud command if the upstream skill requires auth.
- If login is missing or invalid, stop and complete the login flow before continuing.
- If the current CLI session is logged into a different environment, organization, or tenant than the app target the user provided, treat it as a login mismatch and re-run `uip login` against the app target before continuing.
- When re-logging for a mismatch, always use the app configuration target the user provided as input:
  - environment (`cloud`, `staging`, `alpha`)
  - organization
  - tenant
- Do not continue with a publish or deploy path while the CLI session still points at a different org, tenant, or environment than the requested app target.

## Deploy command behavior

- For normal deploys, do not add `--version` to `uip codedapp deploy`.
- Only pass `--version` if the user explicitly wants to deploy a specific published version.

## Sites behavior

- `@Sites` is only the user-facing invocation and product brief context in this flow.
- Do not use Sites starters, vinext templates, Cloudflare Worker output, `.openai/hosting.json`, D1, R2, SIWC, OpenAI workspace auth headers, or Sites deployment for matched UiPath coded-app requests.
- Never fall back to normal Sites hosting for matched UiPath coded-app requests unless the user explicitly asks for dual deployment.
