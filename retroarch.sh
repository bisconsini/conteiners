#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/retroarch
mkdir -p /arquivos/publicos/docker/compose/retroarch/config
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/retroarch/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/retroarch/compose.yaml
services:
  retroarch:
    image: lscr.io/linuxserver/retroarch:latest
    container_name: retroarch
    
    environment:
      - PUID=1001
      - PGID=1001

    volumes:
      - ./config:/config
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      
    ports:
      - 8085:3000
      
    shm_size: 1gb
        
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]   
docker compose config || exit 1
docker compose up -d
