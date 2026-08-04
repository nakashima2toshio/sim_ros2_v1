#!/usr/bin/env bash
# 各スクリプト共通の定義。リポジトリ直下以外から実行しても動くようにする。
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="${REPO_ROOT}/docker-compose/docker-compose.yml"
COMPOSE=(docker compose -f "${COMPOSE_FILE}")
SERVICE="ros2"
