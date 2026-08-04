#!/usr/bin/env bash
# 各スクリプト共通の定義。リポジトリ直下以外から実行しても動くようにする。
set -euo pipefail

# ---------------------------------------------------------------------------
# 実行場所のガード
# ---------------------------------------------------------------------------
# scripts/*.sh は「ホスト（Mac）側」で実行するラッパである。
# コンテナ内には docker CLI が無いため、誤ってコンテナ内で叩いても動かない。
# 何が起きているか分からないまま詰まるのを防ぐため、明示的に案内して止める。
if [ -f /.dockerenv ] || grep -qa 'docker\|containerd' /proc/1/cgroup 2>/dev/null; then
    cat >&2 <<'MSG'
──────────────────────────────────────────────────────────────
 これはホスト（Mac）側で実行するスクリプトです。
 いまはコンテナの中にいるため実行できません。

   ・別のターミナルを開きたい場合
       → Mac 側で:  cd ~/sim_ros2_v1 && ./scripts/sh.sh

   ・コンテナ内では、そのまま ros2 コマンドを使えます
       ros2 doctor
       ros2 topic list
       colcon build --symlink-install   # ビルドは /workspace/ros2_ws で
──────────────────────────────────────────────────────────────
MSG
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "docker コマンドが見つかりません。Docker Desktop を起動してください。" >&2
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="${REPO_ROOT}/docker-compose/docker-compose.yml"
COMPOSE=(docker compose -f "${COMPOSE_FILE}")
SERVICE="ros2"
