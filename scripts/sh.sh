#!/usr/bin/env bash
# コンテナ内の bash に入る。何枚でも開いてよい（同一コンテナの別シェル）。
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"
exec "${COMPOSE[@]}" exec "${SERVICE}" bash
