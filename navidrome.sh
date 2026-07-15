#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/navidrome
mkdir -p /arquivos/publicos/docker/compose/navidrome/data
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/navidrome/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/navidrome/compose.yaml
services:
  navidrome:
    image: deluan/navidrome:latest
    container_name: navidrome

    volumes:
      - ./data:/data
      - /share/batocera/musicas:/music:ro
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro

    ports:
      - 8090:4533
    
    user: "1001:1001"
    
    labels:
      - homepage.group=Mídia
      - homepage.name=navidrome
      - homepage.icon=navidrome.png
      - homepage.href=http://localhost:8090
      - homepage.description=Servidor de musica

    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]
docker compose config || exit 1
docker compose up -d
