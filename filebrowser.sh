#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/filebrowser/{database,config}
touch /arquivos/publicos/docker/compose/filebrowser/database/filebrowser.db
cd /arquivos/publicos/docker/compose/filebrowser/
#[--------------------------------------------------------------------------------------------]
docker network inspect homelab >/dev/null 2>&1 || \
docker network create homelab
#[--------------------------------------------------------------------------------------------]
cat <<EOF > compose.yaml
name: filebrowser
services:
  filebrowser:
    image: filebrowser/filebrowser:latest
    container_name: filebrowser
    volumes:
      - /arquivos/publicos:/srv
      - ./database/filebrowser.db:/database/filebrowser.db
      - ./config:/config
    ports:
      - "8094:80"
    networks:
      - homelab
    restart: unless-stopped
networks:
  homelab:
    external: true
EOF
#[--------------------------------------------------------------------------------------------]
cat <<EOF > config/settings.json
{
  "port": 80,
  "baseURL": "",
  "address": "",
  "log": "stdout",
  "database": "/database/filebrowser.db",
  "root": "/srv"
}
EOF
#[--------------------------------------------------------------------------------------------]
docker compose up -d
echo "Aguardando inicialização..."
sleep 5
#[--------------------------------------------------------------------------------------------]
SENHA=$(docker logs filebrowser 2>&1 | \
grep "User 'admin' initialized with randomly generated password:" | \
awk '{print $NF}')

echo
echo "===================================="
echo " File Browser instalado"
echo "===================================="
echo "Usuário: admin"

if [ -n "$SENHA" ]; then
    echo "Senha inicial: $SENHA"
else
    echo "Senha já existente ou não encontrada."
    echo "Consulte com:"
    echo "docker logs filebrowser"
fi

echo "===================================="
