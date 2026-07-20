#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/gitea/{data,config}
cd /arquivos/publicos/docker/compose/gitea/
sudo chown -R 1000:1000 data config
#[--------------------------------------------------------------------------------------------]
docker network inspect homelab >/dev/null 2>&1 || \
docker network create homelab
#[--------------------------------------------------------------------------------------------]
cat <<EOF > compose.yaml
name: gitea
services:
  gitea:
    image: gitea/gitea:latest-rootless
    container_name: gitea
    environment:
      TZ: America/Sao_Paulo
      GITEA__service__DISABLE_REGISTRATION: true
      GITEA__service__REQUIRE_SIGNIN_VIEW: true
      GITEA__security__MIN_PASSWORD_LENGTH: 4
      GITEA__security__PASSWORD_COMPLEXITY: off
      GITEA__security__PASSWORD_CHECK_PWN: false
    volumes:
      - ./data:/var/lib/gitea
      - ./config:/etc/gitea
    ports:
      - "8083:3000"
      - "2222:2222"
    networks:
      - homelab
    restart: unless-stopped
networks:
  homelab:
    external: true
EOF
#[--------------------------------------------------------------------------------------------]
docker compose config
docker compose up -d
echo "Gitea instalado com sucesso!"
