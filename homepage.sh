#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/homepage
mkdir -p /arquivos/publicos/docker/compose/homepage/config
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/homepage/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/homepage/compose.yaml
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage

    volumes:
      - ./config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      
    environment:
      HOMEPAGE_ALLOWED_HOSTS: localhost:8088
      
    ports:
      - 8088:3000
          
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]  
docker compose config || exit 1
docker compose up -d
