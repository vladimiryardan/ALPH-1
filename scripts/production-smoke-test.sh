#!/usr/bin/env bash
set -euo pipefail

DOMAIN="atticladderph.com"
WWW_DOMAIN="www.atticladderph.com"

echo "=== AtticLadderPH Production Smoke Test ==="

echo "1. Homepage"
curl -fsS "https://${DOMAIN}/" >/dev/null
echo "PASS"

echo "2. Contact page"
curl -fsS "https://${DOMAIN}/contact.cfm" >/dev/null
echo "PASS"

echo "3. Quote request page"
curl -fsS "https://${DOMAIN}/quoterequest.cfm" >/dev/null
echo "PASS"

echo "4. WWW HTTPS"
curl -fsS "https://${WWW_DOMAIN}/" >/dev/null
echo "PASS"

echo "5. HTTP -> HTTPS redirect"
redirect="$(curl -sS -o /dev/null -w '%{redirect_url}' "http://${DOMAIN}/")"

if [[ "$redirect" != "https://${DOMAIN}/" ]]; then
    echo "FAIL: Expected HTTPS redirect, received: $redirect"
    exit 1
fi
echo "PASS"

echo "6. Expected site content"
homepage="$(curl -fsS "https://${DOMAIN}/")"

if ! grep -qi "Attic Ladder" <<< "$homepage"; then
    echo "FAIL: Expected site content not found"
    exit 1
fi

echo "PASS"

echo "7. TLS certificate"
curl -fsS "https://${DOMAIN}/" >/dev/null
echo "PASS"

echo
echo "All production smoke tests passed."