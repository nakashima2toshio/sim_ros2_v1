#!/usr/bin/env bash
# 学習準備の動作確認（README STEP 2 / 合格条件 C1〜C5）を自動化する。
#
# 実行:
#   ホスト側から:   ./scripts/verify_env.sh
#   コンテナ内から: bash /workspace/scripts/verify_env.sh --in-container
#
# GUI を目視する項目（turtlesim の描画など）は自動判定できないため、
# ここでは「起動できること」までを確認する。目視確認は README STEP 2 を参照。
set -uo pipefail

PASS=0
FAIL=0

check() {
    local label="$1"; shift
    printf '  %-46s' "${label}"
    if "$@" >/tmp/verify_env.log 2>&1; then
        echo "OK"
        PASS=$((PASS + 1))
    else
        echo "NG"
        FAIL=$((FAIL + 1))
        sed 's/^/      | /' /tmp/verify_env.log | head -5
    fi
}

run_in_container() {
    local repo_root
    repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    docker compose -f "${repo_root}/docker-compose/docker-compose.yml" \
        exec -T ros2 bash -lc "bash /workspace/scripts/verify_env.sh --in-container"
}

if [ "${1:-}" != "--in-container" ]; then
    echo "== コンテナ内で動作確認を実行します"
    run_in_container
    exit $?
fi

source /opt/ros/jazzy/setup.bash
[ -f /workspace/ros2_ws/install/setup.bash ] && source /workspace/ros2_ws/install/setup.bash

echo
echo "== C1: ROS 2 環境"
check "ros2 コマンドが使える"            bash -c 'command -v ros2'
check "ros2 doctor が致命的エラーを出さない" bash -c 'ros2 doctor 2>&1 | grep -qv "ERROR"'
check "ROS_DISTRO=jazzy"                 bash -c '[ "${ROS_DISTRO}" = "jazzy" ]'

echo
echo "== C2: GUI と turtlesim"
check "X ディスプレイに接続できる"        xdpyinfo
check "turtlesim パッケージが存在する"    bash -c 'ros2 pkg list | grep -qx turtlesim'
check "turtlesim_node が起動する"         timeout 8 bash -c 'ros2 run turtlesim turtlesim_node & sleep 5; ros2 node list | grep -q turtlesim'

echo
echo "== C3: ノード間通信"
check "talker/listener が疎通する" timeout 20 bash -c '
    ros2 run demo_nodes_py talker >/dev/null 2>&1 &
    sleep 3
    timeout 8 ros2 topic echo /chatter --once | grep -q "Hello World"'

echo
echo "== C4: 可視化ツール"
check "rviz2 が存在する"                  bash -c 'command -v rviz2'
check "rqt_graph パッケージが存在する"     bash -c 'ros2 pkg list | grep -qx rqt_graph'

echo
echo "== C5: Gazebo"
check "gz コマンドが使える"               bash -c 'command -v gz'
check "gz sim のバージョンが取得できる"    bash -c 'gz sim --versions'
check "ros_gz_bridge が存在する"          bash -c 'ros2 pkg list | grep -qx ros_gz_bridge'

echo
echo "== 追加: 学習で使うパッケージ"
check "slam_toolbox が存在する"           bash -c 'ros2 pkg list | grep -qx slam_toolbox'
check "nav2_bringup が存在する"           bash -c 'ros2 pkg list | grep -qx nav2_bringup'
check "foxglove_bridge が存在する"        bash -c 'ros2 pkg list | grep -qx foxglove_bridge'

echo
echo "----------------------------------------"
echo "  合格: ${PASS} / 不合格: ${FAIL}"
echo "----------------------------------------"
if [ "${FAIL}" -gt 0 ]; then
    echo "  → docs/troubleshooting.md の症状別インデックスを参照してください"
    exit 1
fi
echo "  → 学習準備の動作確認は完了です（README 4.7）"
