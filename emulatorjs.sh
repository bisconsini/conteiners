#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/emulatorjs
mkdir -p /arquivos/publicos/docker/compose/emulatorjs/config
mkdir -p /arquivos/publicos/docker/compose/emulatorjs/data
mkdir -p /arquivos/publicos/docker/compose/emulatorjs/roms
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/emulatorjs/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/emulatorjs/compose.yaml
services:
  emulatorjs:
    image: lscr.io/linuxserver/emulatorjs:amd64-1.9.2
    container_name: emulatorjs
  
    environment:
      PUID: 1001
      PGID: 1001
    
    volumes:
      - ./config:/config
      - ./data:/data
      - ./roms:/roms
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
              
    ports:
      - 3000:3000
      - 8092:80
       
    labels:
      - homepage.group=Jogos
      - homepage.name=emulatorjs
      - homepage.icon=emulatorjs.png
      - homepage.href=http://localhost:8092
      - homepage.description=Emuladores
        
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]   
docker compose config || exit 1
docker compose up -d
