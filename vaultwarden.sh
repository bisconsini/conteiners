#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/vaultwarden
mkdir -p /arquivos/publicos/docker/compose/vaultwarden/data
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/vaultwarden/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/vaultwarden/compose.yaml
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden

    volumes:
      - ./data:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      
    ports:
      - 8082:80
        
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]    
docker compose config || exit 1
docker compose up -d
