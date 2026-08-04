#!/usr/bin/env bash
# コンテナ内で colcon build を実行する。
#   ./scripts/build.sh                 全パッケージ
#   ./scripts/build.sh sim_nodes_py    指定パッケージのみ
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
if [ $# -gt 0 ]; then
    SELECT="--packages-select $*"
else
    SELECT=""
fi
exec "${COMPOSE[@]}" exec "${SERVICE}" bash -lc \
    "cd /workspace/ros2_ws && colcon build --symlink-install ${SELECT}"
