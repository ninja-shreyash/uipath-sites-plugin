#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:?environment required (cloud|staging|alpha)}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UIP="$("$SCRIPT_DIR/resolve-private-uip.sh")"

case "$ENVIRONMENT" in
  cloud)
    echo "Starting UiPath login for cloud..."
    "$UIP" login
    ;;
  staging)
    echo "Starting UiPath login for staging..."
    "$UIP" login --authority https://staging.uipath.com
    ;;
  alpha)
    echo "Starting UiPath login for alpha..."
    "$UIP" login --authority https://alpha.uipath.com
    ;;
  *)
    echo "Unsupported environment '$ENVIRONMENT'. Use cloud, staging, or alpha." >&2
    exit 1
    ;;
esac
