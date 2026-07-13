#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/phpmyadmin
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/phpmyadmin/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/phpmyadmin/compose.yaml
services:
  phpmyadmin:
    image: phpmyadmin
    container_name: phpmyadmin

    environment:
      PMA_HOST: mariadb
      PMA_PORT: 3306

    ports:
      - 8086:80
      
    networks:
      - backend

    labels:
      - homepage.group=Bancos
      - homepage.name=phpMyAdmin
      - homepage.icon=phpmyadmin.png
      - homepage.href=http://localhost:8086
      - homepage.description=Administração MariaDB/MySQL

    restart: unless-stopped

networks:
  backend:
    external: true
EOF
#[--------------------------------------------------------------------------------------------]  
docker compose config || exit 1
docker compose up -d
