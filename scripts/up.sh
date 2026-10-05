#!/usr/bin/env bash
# コンテナを起動する。
#   1. 公開するホスト側ポートが空いているかを先に確かめる
#   2. イメージが無ければ先にビルドする（Docker Hub への無用な pull を避ける）
#   3. 起動する
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

# .env があれば、その値でポート番号を決める（無ければ既定値）
env_value() {
    local key="$1" default="$2" value=""
    if [ -f "${ENV_FILE}" ]; then
        # grep は該当行が無いと終了コード 1 を返す。set -e / pipefail で止まらないよう || true を付ける
        value="$(grep -E "^${key}=" "${ENV_FILE}" | tail -1 | cut -d= -f2- | tr -d '"'"'"' ' || true)"
    fi
    echo "${value:-$default}"
}

NOVNC_PORT="$(env_value NOVNC_PORT 6080)"
FOXGLOVE_PORT="$(env_value FOXGLOVE_PORT 8765)"
DEBUGPY_PORT="$(env_value DEBUGPY_PORT 5678)"

# ---------------------------------------------------------------------------
# 1. ポートの空き確認
# ---------------------------------------------------------------------------
# 自分のコンテナが既に使っている場合は衝突ではないので、起動中なら確認を飛ばす。
if command -v lsof >/dev/null 2>&1 && [ -z "$("${COMPOSE[@]}" ps -q "${SERVICE}" 2>/dev/null)" ]; then
    busy=0
    for entry in "NOVNC_PORT:${NOVNC_PORT}" "FOXGLOVE_PORT:${FOXGLOVE_PORT}" "DEBUGPY_PORT:${DEBUGPY_PORT}"; do
        key="${entry%%:*}"; port="${entry##*:}"
        # lsof は「該当なし（＝ポートが空いている）」のとき終了コード 1 を返す。
        # set -e / pipefail のままだと、正常な状況でスクリプトが黙って終了してしまうため || true を付ける
        owner="$(lsof -nP -iTCP:"${port}" -sTCP:LISTEN 2>/dev/null | awk 'NR==2 {print $1" (PID "$2")"}' || true)"
        if [ -n "${owner}" ]; then
            echo "✗ ポート ${port}（${key}）は既に使われています: ${owner}" >&2
            busy=1
        fi
    done
    if [ "${busy}" -eq 1 ]; then
        cat >&2 <<MSG

  対処: そのアプリを止めるか、別の番号に変えてください。
        番号を変える場合はリポジトリ直下の .env に書きます（例）:
            cp .env.example .env      # 初回のみ
            # .env を編集して NOVNC_PORT=6081 などに変更
  詳細: docs/troubleshooting.md 7.4
MSG
        exit 1
    fi
fi

# ---------------------------------------------------------------------------
# 2. イメージが無ければ先にビルドする
# ---------------------------------------------------------------------------
# docker-compose.yml は image: と build: の両方を持つ。イメージが無い状態で up すると、
# Compose はまず Docker Hub から sim_ros2_v1:jazzy を pull しようとして
# "pull access denied" を表示する（その後ビルドに進むので実害は無いが紛らわしい）。
if ! docker image inspect "${IMAGE}" >/dev/null 2>&1; then
    echo "イメージ ${IMAGE} が無いのでビルドします（初回は 20〜40 分かかります）"
    "${COMPOSE[@]}" build
fi

# ---------------------------------------------------------------------------
# 3. 起動
# ---------------------------------------------------------------------------
"${COMPOSE[@]}" up -d
"${COMPOSE[@]}" ps
echo
echo "GUI (noVNC): http://localhost:${NOVNC_PORT}/vnc.html"
echo "コンテナに入る: ./scripts/sh.sh"
