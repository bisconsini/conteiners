#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/gitea
mkdir -p /arquivos/publicos/docker/compose/gitea/data
mkdir -p /arquivos/publicos/docker/compose/gitea/config
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/gitea/
#[--------------------------------------------------------------------------------------------]
sudo chown -R 1000:1000 data config
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/gitea/compose.yaml
services:
  gitea:
    image: gitea/gitea:latest-rootless
    container_name: gitea

    volumes:
      - ./data:/var/lib/gitea
      - ./config:/etc/gitea
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      
    ports:
      - 8083:3000
      - 2222:2222
      
    labels:
      - homepage.group=Desenvolvimento
      - homepage.name=Gitea
      - homepage.icon=gitea.png
      - homepage.href=http://localhost:8083
      - homepage.description=Servidor Git pessoal
      
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]  
docker compose config || exit 1
docker compose up -d
