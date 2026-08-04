# Humble ↔ Jazzy 差分早見表

本プロジェクトは **ROS 2 Jazzy** を採用しているが、Web 上の記事・書籍・チュートリアルの
多くは **Humble** を前提としている。**Humble 向けの情報を Jazzy 環境で読み替えるための表**。

---

## 目次

1. [基本情報の比較](#1-基本情報の比較)
2. [なぜ Jazzy を選んだか](#2-なぜ-jazzy-を選んだか)
3. [ドキュメントの読み替え](#3-ドキュメントの読み替え)
4. [Gazebo — 最大の差分](#4-gazebo--最大の差分)
5. [パッケージ名・コマンドの差分](#5-パッケージ名コマンドの差分)
6. [チュートリアル構成の差分](#6-チュートリアル構成の差分)
7. [Humble 向け情報を読むときの注意](#7-humble-向け情報を読むときの注意)

---

## 1. 基本情報の比較

| 項目 | Humble Hawksbill | **Jazzy Jalisco（本プロジェクト）** |
|---|---|---|
| リリース | 2022年5月 | 2024年5月 |
| サポート期限 | 2027年5月 | **2029年5月** |
| 対応 Ubuntu | 22.04 (Jammy) | **24.04 (Noble)** |
| Python | 3.10 | **3.12** |
| 対応 Gazebo | Fortress（`ign gazebo`）— **2026年9月 EOL** | **Harmonic（`gz sim`）— 2028年9月まで** |
| 既定 RMW | `rmw_fastrtps_cpp` | `rmw_fastrtps_cpp` |
| 日本語情報の量 | **非常に多い** | まだ少ない |

> 対応バージョンの定義は [REP-2000](https://ros.org/reps/rep-2000.html) が正本。

---

## 2. なぜ Jazzy を選んだか

本プロジェクトが Humble ではなく Jazzy を採用した理由は **Gazebo** にある。

| 観点 | 判断 |
|---|---|
| チュートリアルの内容 | Humble と Jazzy でほぼ同一（差分は 6 章）。**採用理由にならない** |
| サポート期限 | Jazzy が 2 年長い。学習資産の寿命として有利 |
| **Gazebo** | **Humble が対とする Fortress は 2026年9月に EOL。** 学習の後半（S4〜S6）が着手直後に非推奨環境になる |
| Python | 3.12 が使える（ホスト側 `tools/` とバージョンを揃えられる） |
| 日本語情報 | Humble が有利。ただし本ドキュメントで差分を吸収する |

**結論:** チュートリアルは Humble のものを読んでよいが、**実行環境は Jazzy** とする。

---

## 3. ドキュメントの読み替え

### 3.1 URL の置換

公式ドキュメントは、URL のディストリ名部分を置き換えるだけで対応版が開く。

```
https://docs.ros.org/en/humble/Tutorials/...
                        ↓
https://docs.ros.org/en/jazzy/Tutorials/...
```

**ページ構成・見出し・本文はほぼ同一**なので、Humble のリンクを見つけたら
`humble` → `jazzy` に書き換えて読むのが最も安全。

### 3.2 apt パッケージ名

```bash
# Humble 向けの記事
sudo apt install ros-humble-navigation2

# Jazzy 環境ではこう読み替える
sudo apt install ros-jazzy-navigation2
```

`ros-<distro>-<package>` の `<distro>` 部分を置き換えるだけでよい。

### 3.3 setup.bash のパス

```bash
source /opt/ros/humble/setup.bash    # Humble
source /opt/ros/jazzy/setup.bash     # Jazzy（本プロジェクト）
```

### 3.4 Python のパス

```
/opt/ros/humble/lib/python3.10/site-packages    # Humble
/opt/ros/jazzy/lib/python3.12/site-packages     # Jazzy
```

PyCharm の Interpreter Paths 設定で間違えやすい箇所
（[README STEP 4](../README.md#62-rclpy-の補完を効かせる)）。

---

## 4. Gazebo — 最大の差分

**Humble 向け情報をそのまま実行すると必ず失敗するのがここ。**

### 4.1 3 世代の Gazebo

| 世代 | 実行コマンド | ROS 連携パッケージ | 対応 ROS 2 | 状態 |
|---|---|---|---|---|
| Gazebo Classic（〜11） | `gazebo` | `gazebo_ros_pkgs` | 〜Humble | **EOL（2025年1月）** |
| Ignition / Gazebo Fortress | `ign gazebo` | `ros_ign` / `ros_gz` | Humble | **2026年9月 EOL** |
| **Gazebo Harmonic** | **`gz sim`** | **`ros_gz`** | **Jazzy** | **現行（2028年9月まで）** |

> 名称の変遷が混乱の元になっている。Gazebo は一度 "Ignition" に改称し、
> その後 "Gazebo"（新）に戻った。**記事の日付とコマンド名で世代を判別する**とよい。

### 4.2 コマンドの読み替え

| Humble（Fortress） | Jazzy（Harmonic） |
|---|---|
| `ign gazebo -v 4 world.sdf` | `gz sim -v 4 world.sdf` |
| `ign topic -l` | `gz topic -l` |
| `ign service -l` | `gz service -l` |
| `IGN_GAZEBO_RESOURCE_PATH` | `GZ_SIM_RESOURCE_PATH` |
| `ros_ign_bridge` | `ros_gz_bridge` |
| `ros_ign_sim` | `ros_gz_sim` |

### 4.3 具体例

公式 Humble チュートリアル「Setting up a robot simulation (Gazebo)」の冒頭コマンドは
次のように書かれている。

```bash
# Humble のチュートリアル本文（そのままでは動かない）
ign gazebo -v 4 -r visualize_lidar.sdf
```

**Jazzy 環境での読み替え**

```bash
gz sim -v 4 -r visualize_lidar.sdf
```

---

## 5. パッケージ名・コマンドの差分

| 領域 | Humble | Jazzy | 備考 |
|---|---|---|---|
| Gazebo ブリッジ | `ros-humble-ros-gz` | `ros-jazzy-ros-gz` | Harmonic 対応版 |
| Nav2 | `ros-humble-navigation2` | `ros-jazzy-navigation2` | 設定パラメータに一部変更あり |
| SLAM | `ros-humble-slam-toolbox` | `ros-jazzy-slam-toolbox` | 使い方は同等 |
| `ros2 pkg create` | `--license` は任意 | **`--license` の指定が推奨**（省略すると警告） | |
| Python パッケージング | `setup.py` 中心 | `setup.py` は動くが非推奨警告が出ることがある | 学習には影響なし |

> **本プロジェクトの範囲（学習用途）では、上記以外の実質的な差分はほとんど無い。**
> ノードの書き方、`rclpy` の API、launch の記法は Humble と Jazzy で共通と考えてよい。

---

## 6. チュートリアル構成の差分

公式チュートリアルの目次を Humble / Jazzy 両ブランチで突き合わせた結果、
**構成上の差分は 1 章のみ**だった。

| セクション | 差分 |
|---|---|
| Beginner: CLI tools（10章） | **差分なし** |
| Beginner: Client libraries（13章） | **差分なし** |
| Intermediate | Jazzy に `Monitoring for parameter changes (Python)` が追加（C++ 版のみだった） |
| Advanced | **構成上の差分なし**（Gazebo 章の本文は Harmonic 向けに更新） |
| Demos / Miscellaneous | 差分なし |

**つまり「Humble のチュートリアルを読みながら Jazzy 環境で進める」ことの
学習上のコストはほぼゼロ**である。注意が必要なのは Gazebo 章（4 章）のみ。

全目次は [`ros2_tutorial_index.md`](ros2_tutorial_index.md) を参照。

---

## 7. Humble 向け情報を読むときの注意

日本語のブログ記事・書籍を参照する際のチェックリスト。

| チェック | 対処 |
|---|---|
| `source /opt/ros/humble/setup.bash` が出てくる | `jazzy` に読み替える |
| `apt install ros-humble-*` が出てくる | `ros-jazzy-*` に読み替える |
| `ign gazebo` / `gazebo` コマンドが出てくる | **`gz sim` に読み替える。設定ファイル形式も異なる可能性あり（要注意）** |
| `python3.10` のパスが出てくる | `python3.12` に読み替える |
| Nav2 のパラメータ YAML をコピーしている | **そのまま使えないことがある。** Jazzy 版のサンプルを起点にする |
| 記事が 2023 年以前 | Gazebo 周りは特に慎重に。ROS 2 の基礎部分は問題なく通用する |

**基礎（S1〜S3）は Humble 向け情報がほぼそのまま使える。
シミュレーション以降（S4〜）は Jazzy / Harmonic の一次情報を優先する**、という
使い分けが実務的である。

---

## 参考リンク

| リンク | 内容 |
|---|---|
| [REP-2000](https://ros.org/reps/rep-2000.html) | ディストリごとの対応バージョン定義（Gazebo の対応もここ） |
| [ROS 2 Releases](https://docs.ros.org/en/rolling/Releases.html) | 各ディストリのサポート期限 |
| [Gazebo Releases](https://gazebosim.org/docs/all/releases) | Gazebo 各世代のサポート期限 |
| [ros_gz](https://github.com/gazebosim/ros_gz) | ROS 2 と Gazebo の対応表（README に版の一覧あり） |

---

## 変更履歴

| 日付 | 内容 |
|---|---|
| 2026-08-04 | 初版。README の附録として作成 |
