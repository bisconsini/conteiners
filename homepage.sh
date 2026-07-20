#!/bin/bash

set -e
#[--------------------------------------------------------------------------------------------]
mkdir -p /arquivos/publicos/docker/compose/homepage/config
cd /arquivos/publicos/docker/compose/homepage/
#[--------------------------------------------------------------------------------------------]
docker network inspect homelab >/dev/null 2>&1 || \
docker network create homelab
#[--------------------------------------------------------------------------------------------]
cat <<EOF > compose.yaml
name: homepage
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    volumes:
      - ./config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      HOMEPAGE_ALLOWED_HOSTS: "*"
      TZ: America/Sao_Paulo
    ports:
      - "8086:3000"
    networks:
      - homelab
    restart: unless-stopped
networks:
  homelab:
    external: true
EOF
#[--------------------------------------------------------------------------------------------]
cat <<EOF > config/docker.yaml
my-docker:
  socket: /var/run/docker.sock
EOF
#[--------------------------------------------------------------------------------------------]
cat <<EOF > config/settings.yaml
title: Homelab

language: pt-BR
EOF
#[--------------------------------------------------------------------------------------------]
cat <<EOF > config/services.yaml
- Multimídia:
    - Jellyfin:
        icon: jellyfin
        href: https://jellyfin.bisconsini.uk/
        description: Servidor de filmes, séries, músicas, fotos e vídeos

    - Navidrome:
        icon: navidrome
        href: https://navidrone.bisconsini.uk/
        description: Servidor de música


- Nuvem:
    - Nextcloud:
        icon: nextcloud
        href: https://nextcloud.bisconsini.uk/
        description: Nuvem pessoal


- Desenvolvimento:
    - Gitea:
        icon: gitea
        href: https://gitea.bisconsini.uk/
        description: Servidor Git pessoal


- Downloads:
    - Transmission:
        icon: transmission
        href: https://transmission.bisconsini.uk/
        description: Cliente Torrent


- Administração:
    - FileBrowser:
        icon: filebrowser
        href: https://filebrowser.bisconsini.uk/
        description: Gerenciador de arquivos

    - Dockge:
        icon: dockge
        href: https://dockge.bisconsini.uk/
        description: Gerenciamento de stacks Docker
EOF
#[--------------------------------------------------------------------------------------------]
cat <<EOF > config/bookmarks.yaml
- E-Mail:
    - Gmail:
        - abbr: GM
          href: https://mail.google.com/

    - Outlook:
        - abbr: OL
          href: https://outlook.live.com/


- Inteligência Artificial:
    - ChatGPT:
        - abbr: CG
          href: https://chatgpt.com/

    - Gemini:
        - abbr: GE
          href: https://gemini.google.com/


- Entretenimento:
    - YouTube:
        - abbr: YT
          href: https://www.youtube.com/

    - TikTok:
        - abbr: TT
          href: https://www.tiktok.com/
EOF
#[--------------------------------------------------------------------------------------------]
docker compose config || exit 1
docker compose up -d
echo "Homepage instalado com sucesso!"
