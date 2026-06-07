#!/usr/bin/env bash
set -euo pipefail

RUNTIME_ROOT="${HOME}/.uipath-sites/runtime"
RUNTIME_PREFIX="${RUNTIME_ROOT}/node"
RUNTIME_BIN_DIR="${RUNTIME_PREFIX}/bin"
RUNTIME_METADATA="${RUNTIME_ROOT}/runtime.json"
PINNED_UIP_VERSION="1.0.4"

if ! command -v npm >/dev/null 2>&1; then
  echo "npm not found on PATH. Install Node.js/npm before bootstrapping UiPath." >&2
  exit 1
fi

mkdir -p "$RUNTIME_ROOT"

install_private_uip() {
  rm -rf "$RUNTIME_PREFIX"
  mkdir -p "$RUNTIME_PREFIX"
  echo "Installing private UiPath CLI @uipath/cli@${PINNED_UIP_VERSION} ..."
  npm install --prefix "$RUNTIME_PREFIX" "@uipath/cli@${PINNED_UIP_VERSION}"
}

resolve_private_uip_path() {
  local npm_bin_path="$RUNTIME_PREFIX/node_modules/.bin/uip"
  local package_json="$RUNTIME_PREFIX/node_modules/@uipath/cli/package.json"

  if [ -x "$npm_bin_path" ]; then
    printf '%s\n' "$npm_bin_path"
    return 0
  fi

  if [ -f "$package_json" ]; then
    local package_rel
    package_rel="$(python3 - <<'PY' "$package_json"
import json, sys
with open(sys.argv[1], "r", encoding="utf-8") as f:
    data = json.load(f)
bin_field = data.get("bin")
if isinstance(bin_field, str):
    print(bin_field)
elif isinstance(bin_field, dict):
    print(next(iter(bin_field.values()), ""))
else:
    print("")
PY
)"

    if [ -n "$package_rel" ]; then
      local package_path="$RUNTIME_PREFIX/node_modules/@uipath/cli/$package_rel"
      if [ -x "$package_path" ]; then
        printf '%s\n' "$package_path"
        return 0
      fi
    fi
  fi

  return 1
}

if ! RUNTIME_UI_PATH="$(resolve_private_uip_path)"; then
  install_private_uip
  RUNTIME_UI_PATH="$(resolve_private_uip_path || true)"
fi

current_version="$("$RUNTIME_UI_PATH" --version 2>/dev/null || true)"
if [ "$current_version" != "$PINNED_UIP_VERSION" ]; then
  install_private_uip
  RUNTIME_UI_PATH="$(resolve_private_uip_path || true)"
fi

if [ -z "${RUNTIME_UI_PATH:-}" ] || [ ! -x "$RUNTIME_UI_PATH" ]; then
  echo "Private UiPath CLI install completed, but the executable path could not be resolved." >&2
  exit 1
fi

echo "Verifying private UiPath CLI..."
"$RUNTIME_UI_PATH" --version >/dev/null

echo "Ensuring official UiPath Codex skills are installed..."
"$RUNTIME_UI_PATH" skills install --agent codex

echo "Ensuring UiPath codedapp tool is installed..."
"$RUNTIME_UI_PATH" tools install codedapp

cat >"$RUNTIME_METADATA" <<EOF
{
  "cliVersion": "${PINNED_UIP_VERSION}",
  "uipPath": "${RUNTIME_UI_PATH}",
  "verifiedVersion": "$("$RUNTIME_UI_PATH" --version)",
  "updatedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF

echo "UiPath bootstrap complete."
