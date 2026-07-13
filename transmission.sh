#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/transmission
mkdir -p /arquivos/publicos/docker/compose/transmission/config
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/transmission/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/transmission/compose.yaml
services:
  transmission:
    image: lscr.io/linuxserver/transmission:latest
    container_name: transmission

    environment:
      - PUID=1001
      - PGID=1001
      
    volumes:
      - ./config:/config
      - /arquivos/publicos/temporarios:/watch
      - /arquivos/publicos/downloads:/downloads
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
            
    ports:
      - 8084:9091
      - 51413:51413
      - 51413:51413/udp
      
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]    
docker compose config || exit 1
docker compose up -d
