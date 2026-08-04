#!/usr/bin/env bash
# コンテナを停止・削除する。ビルド成果物のボリュームは残る。
#   ./scripts/down.sh -v   でボリュームごと破棄（やり直したいとき）
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
exec "${COMPOSE[@]}" down "$@"
