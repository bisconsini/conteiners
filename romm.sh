#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/romm
mkdir -p /arquivos/publicos/docker/compose/romm/assets
mkdir -p /arquivos/publicos/docker/compose/romm/config
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/romm/
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/romm/compose.yaml
services:

  romm:
    image: rommapp/romm:latest
    container_name: romm
    restart: unless-stopped

    environment:
      DB_HOST: romm-db
      DB_NAME: romm
      DB_USER: romm-user
      DB_PASSWD: senha_usuario_romm

      ROMM_AUTH_SECRET_KEY: 85734c9f4eafee8271d7770e28500a37b93454e094482c3b19542e8a49d36813

      HASHEOUS_API_ENABLED: true

      SCREENSCRAPER_USER: bisconsini
      SCREENSCRAPER_PASSWORD: 901177

    volumes:
      # Banco de dados interno do RomM
      - romm_resources:/romm/resources

      # Dados baixados (capas, screenshots, etc.)
      - ./assets:/romm/assets

      # Configuração do RomM
      - ./config:/romm/config
      
    ports:
      - "8095:8080"

    depends_on:
      romm-db:
        condition: service_healthy


  romm-db:
    image: mariadb:latest
    container_name: romm-db
    restart: unless-stopped

    environment:
      MARIADB_ROOT_PASSWORD: senha_root_romm

      MARIADB_DATABASE: romm
      MARIADB_USER: romm-user
      MARIADB_PASSWORD: senha_usuario_romm

    volumes:
      - mysql_data:/var/lib/mysql

    healthcheck:
      test:
        [
          "CMD",
          "healthcheck.sh",
          "--connect",
          "--innodb_initialized"
        ]
      start_period: 30s
      interval: 10s
      timeout: 5s
      retries: 5


volumes:

  mysql_data:

  romm_resources:
EOF
#[--------------------------------------------------------------------------------------------]   
docker compose config || exit 1
docker compose up -d
