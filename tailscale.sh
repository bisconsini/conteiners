#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/tailscale
mkdir -p /arquivos/publicos/docker/compose/tailscale/data
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/tailscale/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/tailscale/compose.yaml
services:
  tailscale:
    image: tailscale/tailscale
    container_name: tailscale

    volumes:
      - ./data:/var/lib/tailscale
      - /dev/net/tun:/dev/net/tun
      
    network_mode: host
    
    cap_add:
      - NET_ADMIN
      - NET_RAW
      
    environment:
      TS_STATE_DIR: /var/lib/tailscale
      
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]
docker compose config || exit 1
docker compose up -d
docker exec -it tailscale sh
tailscale up --reset
