#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${1:?app name required}"
VERSION="${2:?version required}"
DIST="${3:-dist}"
FOLDER_KEY="${4:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/bootstrap-uipath-env.sh"
UIP="$("$SCRIPT_DIR/resolve-private-uip.sh")"
"$SCRIPT_DIR/check-uipath-login.sh"

if [ ! -f package.json ]; then
  echo "package.json not found in current directory." >&2
  exit 1
fi

if [ ! -d node_modules ]; then
  echo "node_modules missing. Run 'npm install' before publishing." >&2
  exit 1
fi

echo "Building app..."
npm run build

if [ ! -d "$DIST" ]; then
  echo "Build output directory '$DIST' not found after build." >&2
  exit 1
fi

echo "Packing coded app..."
"$UIP" codedapp pack "$DIST" -n "$APP_NAME" --version "$VERSION" --content-type webapp

echo "Publishing coded app..."
"$UIP" codedapp publish --name "$APP_NAME" --version "$VERSION" --type Web

echo "Deploying coded app..."
if [ -n "$FOLDER_KEY" ]; then
  "$UIP" codedapp deploy --name "$APP_NAME" --version "$VERSION" --folder-key "$FOLDER_KEY"
else
  "$UIP" codedapp deploy --name "$APP_NAME" --version "$VERSION"
fi
