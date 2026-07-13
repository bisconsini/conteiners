#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/mariadb
mkdir -p /arquivos/publicos/docker/compose/mariadb/data
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/mariadb/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/mariadb/compose.yaml
services:
  mariadb:
    image: mariadb
    container_name: mariadb

    volumes:
      - ./data:/var/lib/mysql
      
    environment:
      MARIADB_ROOT_PASSWORD: minhasenha
      
    networks:
      - backend

    restart: unless-stopped
    
networks:
  backend:
    external: true
EOF
#[--------------------------------------------------------------------------------------------]  
docker compose config || exit 1
docker compose up -d
