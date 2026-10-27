#!/usr/bin/env bash
# Makes a dated copy of the vault data in ./backups.
# Copy these files somewhere off the VPS too (your laptop, cloud drive).
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p backups
stamp=$(date +%Y-%m-%d_%H%M)
docker compose stop vaultwarden
tar -czf "backups/vault-$stamp.tar.gz" vw-data
docker compose start vaultwarden
echo "Saved backups/vault-$stamp.tar.gz"
