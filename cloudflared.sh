#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/cloudflared/
cd /arquivos/publicos/docker/compose/cloudflared/
#[--------------------------------------------------------------------------------------------]
docker network inspect homelab >/dev/null 2>&1 || \
docker network create homelab
#[--------------------------------------------------------------------------------------------]
cat <<EOF > compose.yaml
name: cloudflared

services:
  cloudflared:
    image: cloudflare/cloudflared:latest
    container_name: cloudflared

    command: tunnel --no-autoupdate run --token eyJhIjoiNDY1OGJmMmQzNTEzOGVkYjBjZTBhODE5MWVhY2I5ZWEiLCJ0IjoiZTA2ZGFjZWYtY2U1Ni00OTg5LThlZjYtMzkyYjQ0NGVjODY4IiwicyI6Ik1XRXlNbU0wWlRJdE16Y3pOUzAwTVRjM0xXSmtaV0l0WWpRMVl6QTBZMkU1WTJVNSJ9

    restart: unless-stopped

    networks:
      - homelab

networks:
  homelab:
    external: true
EOF
#[--------------------------------------------------------------------------------------------]
docker compose config || exit 1
docker compose up -d
echo "Cloudflared instalado com sucesso!"
