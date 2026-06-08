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
UIP_PATH = Path.home() / ".uipath-sites" / "runtime" / "node" / "bin" / "uip"

if ENVIRONMENT not in BASE_URLS:
    print(f"Unsupported environment '{ENVIRONMENT}'. Use cloud, staging, or alpha.", file=sys.stderr)
    sys.exit(1)

if not UIP_PATH.exists():
    print(
        f"Private UiPath CLI not found at {UIP_PATH}. Run bootstrap-uipath-env.sh first.",
        file=sys.stderr,
    )
    sys.exit(1)

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
