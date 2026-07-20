#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/nginx
cd /arquivos/publicos/docker/compose/nginx/
#[--------------------------------------------------------------------------------------------]
docker network inspect homelab >/dev/null 2>&1 || \
docker network create homelab
#[--------------------------------------------------------------------------------------------]
cat <<EOF > compose.yaml
name: nginx
services:
  nginx:
    image: nginx:stable
    container_name: nginx
    environment:
      - TZ=America/Sao_Paulo
    volumes:
      - /arquivos/publicos/sites:/usr/share/nginx/html:ro
    ports:
      - "8080:80"
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
echo "Nginx instalado com sucesso!"
