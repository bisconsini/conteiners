#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/gaseousgames
mkdir -p /arquivos/publicos/docker/compose/gaseousgames/config
mkdir -p /arquivos/publicos/docker/compose/gaseousgames/data
mkdir -p /arquivos/publicos/docker/compose/gaseousgames/roms
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/gaseousgames/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/gaseousgames/compose.yaml
services:
  gaseousgames:
    image: gaseousgames/gaseousserver:latest-embeddeddb
    container_name: gaseousgames
  
    environment:
      PUID: 1001
      PGID: 1001
    
    volumes:
      - ./config:/home/gaseous/.gaseous-server
      - ./data:/var/lib/mysql
      - ./roms:/roms  
        
    ports:
      - "8091:80"
      
    labels:
      - homepage.group=Jogos
      - homepage.name=Gaseousgames
      - homepage.icon=gaseous.png
      - homepage.href=http://localhost:8091
      - homepage.description=Emuladores
        
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]   
docker compose config || exit 1
docker compose up -d
