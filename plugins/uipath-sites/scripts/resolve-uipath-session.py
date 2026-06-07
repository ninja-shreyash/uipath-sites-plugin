#!/usr/bin/env python3
import json
import subprocess
import sys
from pathlib import Path

ENVIRONMENT = sys.argv[1] if len(sys.argv) > 1 else "cloud"
BASE_URLS = {
    "cloud": "https://api.uipath.com",
    "staging": "https://staging.api.uipath.com",
    "alpha": "https://alpha.api.uipath.com",
}
RUNTIME_ROOT = Path.home() / ".uipath-sites" / "runtime"
RUNTIME_METADATA = RUNTIME_ROOT / "runtime.json"
FALLBACK_UI_PATH = RUNTIME_ROOT / "node" / "node_modules" / ".bin" / "uip"

if ENVIRONMENT not in BASE_URLS:
    print(f"Unsupported environment '{ENVIRONMENT}'. Use cloud, staging, or alpha.", file=sys.stderr)
    sys.exit(1)

def resolve_uip_path() -> Path:
    if RUNTIME_METADATA.exists():
        with RUNTIME_METADATA.open("r", encoding="utf-8") as handle:
            metadata = json.load(handle)
        configured = metadata.get("uipPath")
        if configured:
            candidate = Path(configured)
            if candidate.exists():
                return candidate

    if FALLBACK_UI_PATH.exists():
        return FALLBACK_UI_PATH

    print(
        "Private UiPath CLI not found. Run bootstrap-uipath-env.sh first.",
        file=sys.stderr,
    )
    sys.exit(1)


UIP_PATH = resolve_uip_path()

result = subprocess.run(
    [str(UIP_PATH), "login", "status", "--output", "json"],
    capture_output=True,
    text=True,
)

if result.returncode != 0:
    print(result.stdout or result.stderr, file=sys.stderr)
    sys.exit(result.returncode)

payload = json.loads(result.stdout)
data = payload.get("Data", {})
session = {
    "environment": ENVIRONMENT,
    "baseUrl": BASE_URLS[ENVIRONMENT],
    "orgName": data.get("Organization"),
    "tenantName": data.get("Tenant"),
    "status": data.get("Status"),
}
print(json.dumps(session, indent=2))
