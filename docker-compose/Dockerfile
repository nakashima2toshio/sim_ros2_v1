# ROS 2 Jazzy 学習環境
#
# ベースは公式の ros:jazzy-ros-base（arm64 / amd64 の両対応）。
# 必要なパッケージだけを明示的に積み上げる。
#   - -desktop-full 系のタグは arm64 での提供が安定しない時期があり、
#     また不要な重量物を抱えるため使わない。
#   - 何が入っているかを Dockerfile から追えることを優先する。
#
# ビルド:
#   docker compose -f docker-compose/docker-compose.yml build
FROM ros:jazzy-ros-base

ARG DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-lc"]

# ---------------------------------------------------------------------------
# ROS 2 パッケージ
# ---------------------------------------------------------------------------
# ros-jazzy-desktop に rviz2 / rqt / turtlesim / demo_nodes_py が含まれる。
RUN apt-get update && apt-get install -y --no-install-recommends \
        ros-jazzy-desktop \
        ros-jazzy-ros2doctor \
        ros-jazzy-tf2-tools \
        ros-jazzy-tf-transformations \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# シミュレータ（Gazebo Harmonic）と自律走行
# ---------------------------------------------------------------------------
# Jazzy が対とする Gazebo は Harmonic（コマンドは gz sim）。
# ros-jazzy-ros-gz が Harmonic 本体とブリッジを引き込む。
RUN apt-get update && apt-get install -y --no-install-recommends \
        ros-jazzy-ros-gz \
        ros-jazzy-ros-gz-bridge \
        ros-jazzy-ros-gz-sim \
        ros-jazzy-navigation2 \
        ros-jazzy-nav2-bringup \
        ros-jazzy-slam-toolbox \
        ros-jazzy-robot-state-publisher \
        ros-jazzy-joint-state-publisher-gui \
        ros-jazzy-xacro \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# 可視化ブリッジ
# ---------------------------------------------------------------------------
#   foxglove_bridge  : Foxglove Studio 接続用（:8765）
#   rosbridge_suite  : 学習後半（S6）の Web UI 用（:9090）
RUN apt-get update && apt-get install -y --no-install-recommends \
        ros-jazzy-foxglove-bridge \
        ros-jazzy-rosbridge-suite \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# GUI 転送（noVNC 方式）
# ---------------------------------------------------------------------------
#   Xvfb        : 仮想ディスプレイ
#   fluxbox     : 最小のウィンドウマネージャ（無いとダイアログが操作できない）
#   x11vnc      : Xvfb の画面を VNC で配信
#   novnc       : VNC をブラウザで見るための Web クライアント
RUN apt-get update && apt-get install -y --no-install-recommends \
        xvfb x11vnc fluxbox novnc websockify \
        x11-utils x11-apps mesa-utils libgl1-mesa-dri \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# 開発補助
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3-colcon-common-extensions \
        python3-rosdep \
        python3-pip \
        python3-pytest \
        git vim less curl wget net-tools iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Ubuntu 24.04 の Python は外部管理（PEP 668）のため --break-system-packages が必要。
# コンテナ内の隔離された環境なので問題にならない。
RUN pip3 install --no-cache-dir --break-system-packages debugpy

# rosdep の初期化（ベースイメージで済んでいる場合もあるため失敗は無視する）
RUN rosdep init 2>/dev/null || true

WORKDIR /workspace/ros2_ws

COPY docker-compose/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 全ターミナルで source が効くようにする（source 忘れは最頻出のトラブル）
RUN echo 'source /opt/ros/jazzy/setup.bash' >> /root/.bashrc \
 && echo '[ -f /workspace/ros2_ws/install/setup.bash ] && source /workspace/ros2_ws/install/setup.bash' >> /root/.bashrc \
 && echo 'cd /workspace/ros2_ws' >> /root/.bashrc

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sleep", "infinity"]
