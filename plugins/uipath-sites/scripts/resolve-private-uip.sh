#!/usr/bin/env bash
set -euo pipefail

RUNTIME_METADATA="${HOME}/.uipath-sites/runtime/runtime.json"
FALLBACK_BIN="${HOME}/.uipath-sites/runtime/node/node_modules/.bin/uip"

if [ -f "$RUNTIME_METADATA" ]; then
  RUNTIME_UI_PATH="$(python3 - <<'PY' "$RUNTIME_METADATA"
import json, sys
with open(sys.argv[1], "r", encoding="utf-8") as f:
    data = json.load(f)
print(data.get("uipPath", ""))
PY
)"
  if [ -n "$RUNTIME_UI_PATH" ] && [ -x "$RUNTIME_UI_PATH" ]; then
    printf '%s\n' "$RUNTIME_UI_PATH"
    exit 0
  fi
fi

if [ -x "$FALLBACK_BIN" ]; then
  printf '%s\n' "$FALLBACK_BIN"
  exit 0
fi

echo "Private UiPath CLI not found. Run bootstrap-uipath-env.sh first." >&2
exit 1
