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
    image: louislam/dockge:1
    container_name: dockge

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/app/data
      - /arquivos/publicos/docker/compose:/arquivos/publicos/docker/compose
      
    ports:
      - 8093:5001
      
    environment:
      - DOCKGE_STACKS_DIR=/arquivos/publicos/docker/compose
      
    labels:
      - homepage.group=Administração
      - homepage.name=Dockge
      - homepage.icon=dockge.png
      - homepage.href=http://localhost:8093
      - homepage.description=Gerenciamento de containers Docker
    
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]
docker compose config || exit 1
docker compose up -d
