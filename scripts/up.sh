#!/usr/bin/env bash
# コンテナを起動する（未ビルドなら自動でビルドされる）。
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
"${COMPOSE[@]}" up -d
"${COMPOSE[@]}" ps
echo
echo "GUI (noVNC): http://localhost:${NOVNC_PORT:-6080}/vnc.html"
echo "コンテナに入る: ./scripts/sh.sh"
