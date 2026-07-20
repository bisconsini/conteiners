#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/nextcloud/nextcloud/data
mkdir -p /arquivos/publicos/docker/compose/nextcloud/mariadb/data
cd /arquivos/publicos/docker/compose/nextcloud
#[--------------------------------------------------------------------------------------------]
docker network inspect homelab >/dev/null 2>&1 || \
docker network create homelab
#[--------------------------------------------------------------------------------------------]
cat <<EOF > compose.yaml
name: nextcloud
services:
  mariadb:
    image: mariadb:latest
    container_name: nextcloud-mariadb
    volumes:
      - ./mariadb/data:/var/lib/mysql
    environment:
      TZ: America/Sao_Paulo
      MARIADB_ROOT_PASSWORD: senha_de_root
      MARIADB_DATABASE: nextcloud
      MARIADB_USER: nextcloud
      MARIADB_PASSWORD: senha_de_usuario
    networks:
      - homelab
    restart: unless-stopped


  redis:
    image: redis:latest
    container_name: nextcloud-redis
    networks:
      - homelab
    restart: unless-stopped


  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud-app
    depends_on:
      - mariadb
      - redis
    volumes:
      - ./nextcloud/data:/var/www/html
    ports:
      - "8085:80"
    environment:
      TZ: America/Sao_Paulo
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: senha_de_usuario
      MYSQL_HOST: nextcloud-mariadb
      REDIS_HOST: nextcloud-redis
      OVERWRITEHOST: nextcloud.bisconsini.uk
      OVERWRITEPROTOCOL: https
      OVERWRITECLIURL: https://nextcloud.bisconsini.uk
      TRUSTED_PROXIES: cloudflared
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
echo "Nextcloud instalado com sucesso!"
