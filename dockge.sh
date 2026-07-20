#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/dockge/data
cd /arquivos/publicos/docker/compose/dockge/
#[--------------------------------------------------------------------------------------------]
docker network inspect homelab >/dev/null 2>&1 || \
docker network create homelab
#[--------------------------------------------------------------------------------------------]
cat <<EOF > compose.yaml
name: dockge
services:
  dockge:
    image: louislam/dockge:1
    container_name: dockge
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/app/data
      - /arquivos/publicos/docker/compose:/arquivos/publicos/docker/compose
    ports:
      - "8088:5001"
    environment:
      DOCKGE_STACKS_DIR: /arquivos/publicos/docker/compose
    networks:
      - homelab
    restart: unless-stopped
networks:
  homelab:
    external: true
EOF
#[--------------------------------------------------------------------------------------------]
docker compose config || exit 1
docker compose up -d
echo "Dockge instalado com sucesso!"
