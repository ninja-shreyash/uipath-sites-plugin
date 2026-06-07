#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-5173}"
HOST="${HOST:-127.0.0.1}"

if [ ! -f package.json ]; then
  echo "package.json not found in current directory." >&2
  exit 1
fi

if [ ! -d node_modules ]; then
  echo "Installing project dependencies..."
  npm install
fi

echo "Starting local app on http://${HOST}:${PORT} ..."
nohup npm run dev -- --host "$HOST" --port "$PORT" >/tmp/uipath-sites-dev.log 2>&1 &
echo "$!" >/tmp/uipath-sites-dev.pid
echo "Local app running at http://${HOST}:${PORT}"
echo "Logs: /tmp/uipath-sites-dev.log"
