#!/usr/bin/env python3
"""Localize IAP display names and descriptions on App Store Connect."""

import base64
import hashlib
import hmac
import json
import ssl
import struct
import subprocess
import time
import urllib.request
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
SECRETS_FILE = SCRIPT_DIR.parent / "Configuration" / "Secrets.xcconfig"
BASE_URL = "https://api.appstoreconnect.apple.com/v1"
BUNDLE_ID = "com.reginafallangi.Listen-anonymously"


def load_secrets():
    secrets = {}
    with open(SECRETS_FILE) as f:
        for line in f:
            line = line.strip()
            if line.startswith("//") or not line or "=" not in line:
                continue
            key, value = line.split("=", 1)
            secrets[key.strip()] = value.strip()
    return secrets


def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode()


def generate_token(secrets):
    key_id = secrets["ASC_KEY_ID"]
    issuer_id = secrets["ASC_ISSUER_ID"]
    key_file = SCRIPT_DIR / f"AuthKey_{key_id}.p8"

    now = int(time.time())
    header = b64url(json.dumps({"alg": "ES256", "kid": key_id, "typ": "JWT"}).encode())
    payload = b64url(json.dumps({
        "iss": issuer_id,
        "iat": now,
        "exp": now + 20 * 60,
        "aud": "appstoreconnect-v1",
    }).encode())

    unsigned = f"{header}.{payload}"

    # Sign with openssl (no external Python deps needed)
    result = subprocess.run(
        ["openssl", "dgst", "-sha256", "-sign", str(key_file)],
        input=unsigned.encode(),
        capture_output=True,
    )
    if result.returncode != 0:
        raise RuntimeError(f"openssl signing failed: {result.stderr.decode()}")

    # openssl produces DER-encoded signature, convert to raw r||s for ES256
    der = result.stdout
    signature = der_to_raw_es256(der)

    return f"{unsigned}.{b64url(signature)}"


def der_to_raw_es256(der: bytes) -> bytes:
    """Convert DER-encoded ECDSA signature to raw 64-byte r||s format."""
    # DER: 0x30 <len> 0x02 <r_len> <r> 0x02 <s_len> <s>
    idx = 2  # skip 0x30 and total length
    if der[0] != 0x30:
        raise ValueError("Invalid DER signature")

    # Handle long form length
    if der[1] & 0x80:
        len_bytes = der[1] & 0x7F
        idx = 2 + len_bytes

    # Read r
    if der[idx] != 0x02:
        raise ValueError("Invalid DER: expected 0x02 for r")
    idx += 1
    r_len = der[idx]
    idx += 1
    r = der[idx:idx + r_len]
    idx += r_len

    # Read s
    if der[idx] != 0x02:
        raise ValueError("Invalid DER: expected 0x02 for s")
    idx += 1
    s_len = der[idx]
    idx += 1
    s = der[idx:idx + s_len]

    # Pad/trim to 32 bytes each
    r = r[-32:].rjust(32, b'\x00')
    s = s[-32:].rjust(32, b'\x00')

    return r + s


def load_yaml(path):
    """Simple YAML loader for flat key-value maps (no external deps)."""
    import re

    result = {}
    current_product = None
    current_locale = None

    with open(path) as f:
        for line in f:
            stripped = line.rstrip()
            if not stripped or stripped.startswith("#"):
                continue

            # Top-level key (product ID) - no leading whitespace
            if not line[0].isspace() and stripped.endswith(":"):
                current_product = stripped[:-1]
                result[current_product] = {}
                continue

            # Locale line: "  en-US: { name: "...", description: "..." }"
            match = re.match(
                r'^\s+([\w-]+):\s*\{\s*name:\s*"(.+?)",\s*description:\s*"(.+?)"\s*\}',
                line
            )
            if match and current_product:
                locale = match.group(1)
                name = match.group(2)
                description = match.group(3)
                result[current_product][locale] = {
                    "name": name,
                    "description": description,
                }

    return result


def asc_request(token, method, path, body=None):
    url = f"{BASE_URL}/{path}" if not path.startswith("http") else path
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
    }
    data = json.dumps(body).encode() if body else None
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    ctx = ssl.create_default_context()

    try:
        with urllib.request.urlopen(req, context=ctx) as resp:
            return json.loads(resp.read())
    except urllib.error.HTTPError as e:
        error_body = e.read().decode()
        raise RuntimeError(f"{method} {path} failed ({e.code}): {error_body}")


def asc_get_all(token, path):
    all_data = []
    url = path
    while url:
        response = asc_request(token, "GET", url)
        all_data.extend(response.get("data", []))
        url = response.get("links", {}).get("next", "")
    return all_data


def main():
    secrets = load_secrets()
    token = generate_token(secrets)

    # Find the app
    print("Finding app...")
    apps = asc_get_all(token, f"apps?filter[bundleId]={BUNDLE_ID}")
    if not apps:
        raise RuntimeError("App not found!")
    app_id = apps[0]["id"]
    print(f"App ID: {app_id}")

    # Load localizations config
    localizations_config = load_yaml(SCRIPT_DIR / "iap_localizations.yml")

    # Fetch all IAPs
    print("Fetching IAPs...")
    iaps = asc_get_all(token, f"apps/{app_id}/inAppPurchasesV2")
    print(f"Found {len(iaps)} IAPs")

    for product_id, locales in localizations_config.items():
        iap = next(
            (i for i in iaps if i["attributes"].get("productId") == product_id), None
        )
        if not iap:
            print(f"WARNING: IAP '{product_id}' not found, skipping...")
            continue

        iap_id = iap["id"]
        print(f"\nLocalizing IAP: {product_id} ({iap_id})")

        # Debug: print relationship links to find correct path
        rels = iap.get("relationships", {})
        for rel_name, rel_data in rels.items():
            links = rel_data.get("links", {})
            if "related" in links:
                print(f"  relationship: {rel_name} -> {links['related']}")

        # Fetch existing localizations
        loc_link = rels.get("inAppPurchaseLocalizations", {}).get("links", {}).get("related", "")
        if loc_link:
            existing = asc_get_all(token, loc_link)
        else:
            # Try the standard path
            existing = asc_get_all(
                token, f"inAppPurchasesV2/{iap_id}/inAppPurchaseLocalizations"
            )
        existing_by_locale = {
            loc["attributes"]["locale"]: loc for loc in existing
        }

        for locale, meta in locales.items():
            name = meta["name"]
            description = meta["description"]

            if locale in existing_by_locale:
                loc_id = existing_by_locale[locale]["id"]
                body = {
                    "data": {
                        "type": "inAppPurchaseLocalizations",
                        "id": loc_id,
                        "attributes": {"name": name, "description": description},
                    }
                }
                asc_request(token, "PATCH", f"inAppPurchaseLocalizations/{loc_id}", body)
                print(f"  Updated {locale}")
            else:
                body = {
                    "data": {
                        "type": "inAppPurchaseLocalizations",
                        "attributes": {
                            "locale": locale,
                            "name": name,
                            "description": description,
                        },
                        "relationships": {
                            "inAppPurchaseV2": {
                                "data": {"type": "inAppPurchases", "id": iap_id}
                            }
                        },
                    }
                }
                asc_request(token, "POST", "inAppPurchaseLocalizations", body)
                print(f"  Created {locale}")

    print("\nIAP localizations updated successfully!")


if __name__ == "__main__":
    main()
