#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/dockge
mkdir -p /arquivos/publicos/docker/compose/dockge/data
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/dockge/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/dockge/compose.yaml
services:
  dockge:
    image: ghcr.io/louislam/dockge:1
    container_name: dockge

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /arquivos/publicos/docker/compose:/opt/stacks
      - ./data:/app/data
      
    ports:
      - 8092:5001
      
    environment:
      - DOCKGE_STACKS_DIR=/opt/stacks
    
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]
docker compose config || exit 1
docker compose up -d
