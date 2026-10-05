#!/usr/bin/env bash
# コンテナ内の bash に入る。何枚でも開いてよい（同一コンテナの別シェル）。
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

# コンテナが起動していないと exec は失敗する。何をすればよいかを案内して止める。
if [ -z "$("${COMPOSE[@]}" ps -q "${SERVICE}" 2>/dev/null)" ]; then
    cat >&2 <<'MSG'
✗ sim_ros2_v1 のコンテナが起動していません。
  先に ./scripts/up.sh を実行してください。
  （Docker Desktop の Containers 画面に「sim_ros2_v1」が表示されていれば起動しています）
MSG
    exit 1
fi

exec "${COMPOSE[@]}" exec "${SERVICE}" bash
