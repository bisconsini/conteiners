#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/nginx
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/nginx/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/nginx/compose.yaml
services:
  nginx:
    image: nginx:stable
    container_name: nginx

    volumes:
      - /arquivos/publicos/sites:/usr/share/nginx/html:ro
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
            
    ports:
      - 8080:80
      
    labels:
      - homepage.group=Web
      - homepage.name=Nginx
      - homepage.icon=nginx.png
      - homepage.href=http://localhost:8080
      - homepage.description=Servidor Web
      
    restart: unless-stopped
EOF
#[--------------------------------------------------------------------------------------------]    
docker compose config || exit 1
docker compose up -d
