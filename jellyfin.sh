#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/jellyfin/{config,cache}
cd /arquivos/publicos/docker/compose/jellyfin/
#[--------------------------------------------------------------------------------------------]
docker network inspect homelab >/dev/null 2>&1 || \
docker network create homelab
#[--------------------------------------------------------------------------------------------]
cat <<EOF > compose.yaml
name: jellyfin
services:
  jellyfin:
    image: jellyfin/jellyfin:2026070606
    container_name: jellyfin
    environment:
      TZ: America/Sao_Paulo
    volumes:
      - ./config:/config
      - ./cache:/cache
      - /arquivos/publicos/filmes:/media/filmes
      - /arquivos/publicos/series:/media/series
      - /arquivos/publicos/musicas:/media/musicas
      - /arquivos/publicos/imagens:/media/imagens
      - /arquivos/publicos/videos:/media/videos
      - /arquivos/publicos/ebooks:/media/ebooks
    ports:
      - "8081:8096"
    user: 1000:1000
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
echo "Jellyfin instalado com sucesso!"
