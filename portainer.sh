#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/portainer
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/portainer/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/portainer/compose.yaml
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer

    ports:
      - 8089:9000

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/data
      
    labels:
      - homepage.group=Administração
      - homepage.name=Portainer
      - homepage.icon=portainer.png
      - homepage.href=http://localhost:8089
      - homepage.description=Gerenciamento de containers Docker

    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]  
docker compose config || exit 1
docker compose up -d
