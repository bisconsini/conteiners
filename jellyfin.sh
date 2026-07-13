#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/jellyfin
mkdir -p /arquivos/publicos/docker/compose/jellyfin/config
mkdir -p /arquivos/publicos/docker/compose/jellyfin/cache
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/jellyfin/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/jellyfin/compose.yaml
services:
  jellyfin:
    image: jellyfin/jellyfin:2026070606
    container_name: jellyfin

    volumes:
      - ./config:/config
      - ./cache:/cache
      - /arquivos/publicos/filmes:/media/filmes
      - /arquivos/publicos/series:/media/series
      - /arquivos/publicos/musicas:/media/musicas
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro

    ports:
      - 8081:8096
    
    user: 1001:1001

    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]
docker compose config || exit 1
docker compose up -d
