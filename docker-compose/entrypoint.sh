#!/usr/bin/env bash
# ROS 2 学習環境のエントリポイント。
#
#   1. GUI（Xvfb + fluxbox + x11vnc + noVNC）を起動する（START_GUI=0 で無効化）
#   2. ROS 2 環境を source する
#   3. CMD を実行する（既定は sleep infinity。作業は docker compose exec で行う）
set -e

# ---------------------------------------------------------------------------
# GUI（noVNC 方式）
# ---------------------------------------------------------------------------
if [ "${START_GUI:-1}" = "1" ]; then
    DISPLAY_NUM="${DISPLAY:-:1}"
    SCREEN_SIZE="${SCREEN_SIZE:-1920x1080x24}"
    VNC_PORT="${VNC_PORT:-5900}"
    NOVNC_PORT="${NOVNC_PORT:-6080}"

    echo "[entrypoint] GUI を起動します (display=${DISPLAY_NUM}, size=${SCREEN_SIZE})"

    Xvfb "${DISPLAY_NUM}" -screen 0 "${SCREEN_SIZE}" >/var/log/xvfb.log 2>&1 &

    # X が受け付けられるようになるまで待つ（起動直後は接続に失敗する）
    for _ in $(seq 1 30); do
        if DISPLAY="${DISPLAY_NUM}" xdpyinfo >/dev/null 2>&1; then break; fi
        sleep 0.5
    done

    DISPLAY="${DISPLAY_NUM}" fluxbox >/var/log/fluxbox.log 2>&1 &
    x11vnc -display "${DISPLAY_NUM}" -forever -shared -nopw \
           -rfbport "${VNC_PORT}" -quiet >/var/log/x11vnc.log 2>&1 &
    websockify --web=/usr/share/novnc "${NOVNC_PORT}" \
           "localhost:${VNC_PORT}" >/var/log/novnc.log 2>&1 &

    echo "[entrypoint] noVNC: http://localhost:${NOVNC_PORT}/vnc.html"
fi

# ---------------------------------------------------------------------------
# ROS 2 環境
# ---------------------------------------------------------------------------
source /opt/ros/jazzy/setup.bash
if [ -f /workspace/ros2_ws/install/setup.bash ]; then
    source /workspace/ros2_ws/install/setup.bash
fi

echo "[entrypoint] ROS 2 $(ros2 --version 2>/dev/null || echo jazzy) / DOMAIN_ID=${ROS_DOMAIN_ID:-0}"

exec "$@"
