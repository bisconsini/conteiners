#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p cd /arquivos/publicos/docker/compose/nextcloud
#[--------------------------------------------------------------------------------------------]
cd /arquivos/publicos/docker/compose/nextcloud
#[--------------------------------------------------------------------------------------------]
cat <<EOF > /arquivos/publicos/docker/compose/nextcloud/compose.yaml
services:
  nextcloud-aio-mastercontainer:
    image: nextcloud/all-in-one:latest
    container_name: nextcloud-aio-mastercontainer

    restart: unless-stopped

    ports:
      - "8087:8080"

    volumes:
      - nextcloud_aio_mastercontainer:/mnt/docker-aio-config
      - /var/run/docker.sock:/var/run/docker.sock:ro

volumes:
  nextcloud_aio_mastercontainer:
    name: nextcloud_aio_mastercontainer
EOF
#[--------------------------------------------------------------------------------------------]  
docker compose config || exit 1
docker compose up -d
