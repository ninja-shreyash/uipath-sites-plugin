# UiPath Sites Plugin

This repo packages the `uipath-sites` Codex companion plugin as a shareable marketplace.

It extends `@Sites` so users can keep the self-contained Sites experience for building and sharing web apps, while switching the final target to **UiPath coded apps** deployed through the UiPath CLI.

## What is included

- `.agents/plugins/marketplace.json`
- `plugins/uipath-sites/`
  - plugin manifest
  - skill
  - reference docs
  - bootstrap, login, local-run, and publish scripts

## Install for demo

Codex marketplaces are path-based, so the reliable install flow is local.

### Option 1: clone the repo

```bash
git clone https://github.com/ninja-shreyash/uipath-sites-plugin.git
cd uipath-sites-plugin
codex plugin marketplace add .
codex plugin add uipath-sites@uipath-sites-marketplace
```

### Option 2: download ZIP

1. Download this repo as ZIP from GitHub.
2. Extract it locally.
3. From the extracted repo root, run:

```bash
codex plugin marketplace add .
codex plugin add uipath-sites@uipath-sites-marketplace
```

## Plugin behavior

On first relevant use, the plugin:

- bootstraps a private `uip` CLI runtime under `~/.uipath-sites/runtime/`
- runs `uip skills install --agent codex`
- runs `uip tools install codedapp`
- drives environment-aware `uip login`
- helps create, verify locally, pack, publish, and deploy coded apps

The plugin does not rely on a system `uip` on `PATH`.

## Example prompt

```text
@Sites create a UiPath coded app to display maestro processes
```
