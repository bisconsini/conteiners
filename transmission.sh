#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/torrents/{completos,incompletos,adicionados}
mkdir -p /arquivos/publicos/docker/compose/transmission/config
chown -R 1000:1000 /arquivos/publicos/torrents
cd /arquivos/publicos/docker/compose/transmission/
#[--------------------------------------------------------------------------------------------]
docker network inspect homelab >/dev/null 2>&1 || \
docker network create homelab
#[--------------------------------------------------------------------------------------------]
cat <<EOF > compose.yaml
name: transmission
services:
  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission
    environment:
      PUID: 1000
      PGID: 1000
      TZ: America/Sao_Paulo
      USER: admin
      PASS: i23456789@
    volumes:
      - ./config:/config
      - /arquivos/publicos/torrents/incompletos:/incomplete
      - /arquivos/publicos/torrents/completos:/downloads
      - /arquivos/publicos/torrents/adicionados:/watch
    ports:
      - 8084:9091
      - 51413:51413
      - 51413:51413/udp
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
echo "Transmission instalado com sucesso!"
