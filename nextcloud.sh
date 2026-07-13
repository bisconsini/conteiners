#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/nextcloud
mkdir -p /arquivos/publicos/docker/compose/nextcloud/nextcloud/data
mkdir -p /arquivos/publicos/docker/compose/nextcloud/mariadb/data
mkdir -p /arquivos/publicos/docker/compose/nextcloud/redis/data
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/nextcloud
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/nextcloud/compose.yaml
services:
  mariadb:
    image: mariadb:latest
    container_name: nextcloud-mariadb

    volumes:
      - ./mariadb/data:/var/lib/mysql

    environment:
      TZ: America/Sao_Paulo
      MARIADB_ROOT_PASSWORD: minhasenharoot
      MARIADB_DATABASE: nextcloud
      MARIADB_USER: nextcloud
      MARIADB_PASSWORD: minhasenha

    restart: unless-stopped
    
  redis:
    image: redis:latest
    container_name: nextcloud-redis

    volumes:
      - ./redis/data:/data

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
      - 8087:80

    environment:
      TZ: America/Sao_Paulo
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: minhasenha
      MYSQL_HOST: nextcloud-mariadb
      REDIS_HOST: nextcloud-redis
      
    labels:
      - homepage.group=Cloud
      - homepage.name=Nextcloud
      - homepage.icon=nextcloud.png
      - homepage.href=http://localhost:8087
      - homepage.description=Nuvem pessoal

    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]  
docker compose config || exit 1
docker compose up -d
