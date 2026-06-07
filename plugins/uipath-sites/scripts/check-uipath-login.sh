#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UIP="$("$SCRIPT_DIR/resolve-private-uip.sh")"

status_json="$("$UIP" login status --output json 2>&1 || true)"
printf '%s\n' "$status_json"

if printf '%s' "$status_json" | grep -q '"Refresh Failed"'; then
  echo "UiPath login refresh failed. Complete the environment-specific 'uip login' flow before continuing." >&2
  exit 1
fi

if printf '%s' "$status_json" | grep -q '"Organization": "N/A"'; then
  echo "UiPath login is not ready. Complete the environment-specific 'uip login' flow before continuing." >&2
  exit 1
fi

if printf '%s' "$status_json" | grep -q '"Tenant": "N/A"'; then
  echo "UiPath login is not ready. Complete the environment-specific 'uip login' flow before continuing." >&2
  exit 1
fi

if ! printf '%s' "$status_json" | grep -q '"Status"'; then
  echo "Unable to verify UiPath login status. Complete the environment-specific 'uip login' flow and retry." >&2
  exit 1
fi

echo "UiPath login looks ready."
