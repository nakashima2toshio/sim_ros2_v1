# P01 環境確認とノードの観察 ★1

| 項目 | 内容 |
|---|---|
| ステージ | S1 観察する（CLI のみ・コードは書かない） |
| 難易度 / 目安 | ★1 / 2 時間 |
| 使うもの | turtlesim、`ros2` コマンド、rqt_graph、ブラウザ（noVNC） |
| 学習計画での位置 | [`docs/learning_plan.md`](../docs/learning_plan.md) 5 章 P01 |
| 対応する公式チュートリアル | Configuring environment / Using turtlesim, ros2, and rqt / Understanding nodes |

**目的:** ROS 2 の部品の単位である「ノード」と、ノード同士の繋がりを**目で見て**理解する。

本書の「期待される結果」に書いたノード名・トピック名・サービス名・ログの文言は、
turtlesim の Jazzy 版のソース（`ros/ros_tutorials` の `jazzy` ブランチ）で確認したものである。

---

## 目次

0. [準備：画面とターミナルを揃える](#0-準備画面とターミナルを揃える)
1. [Step 1 環境を確認する](#step-1-環境を確認する)
2. [Step 2 GUI が映ることを確かめる](#step-2-gui-が映ることを確かめる)
3. [Step 3 turtlesim を起動する](#step-3-turtlesim-を起動する)
4. [Step 4 ノードを観察する](#step-4-ノードを観察する)
5. [Step 5 繋がりを図で見る](#step-5-繋がりを図で見る)
6. [Step 6 繋がりを変えてみる](#step-6-繋がりを変えてみる)
7. [到達確認](#到達確認)
8. [うまくいかないとき](#うまくいかないとき)
9. [到達確認の答え](#到達確認の答え)

---

## 0. 準備：画面とターミナルを揃える

### 0.1 使う画面

| 名前 | 開き方 | 役割 |
|---|---|---|
| **ブラウザ** | `http://localhost:6080/vnc.html` →「**接続**」 | GUI（亀の画面・rqt_graph）を見る |
| **ターミナル A** | Mac で `./scripts/sh.sh` | turtlesim 本体を動かす |
| **ターミナル B** | Mac で `./scripts/sh.sh` | キー操作（teleop）を動かす |
| **ターミナル C** | Mac で `./scripts/sh.sh` | 観察用のコマンドを打つ |

### 0.2 コンテナを起動して、3 枚とも中に入る

Mac のターミナルで、リポジトリのフォルダから実行する。

```bash
./scripts/up.sh        # 1 回だけ。起動済みならそのまま進む
./scripts/sh.sh        # ターミナル A・B・C のそれぞれで実行する
```

**期待される結果:** 3 枚ともプロンプトが次のように変わる。

```
root@ros2:/workspace/ros2_ws#
```

> ⚠️ **ここから先のコマンドはすべて、プロンプトが `root@ros2:` のターミナルで打つ。**
> `nakashima_toshio@Mac` のままで `ros2` を打つと `command not found` になる。

---

## Step 1 環境を確認する

**ターミナル A** で実行する。

```bash
printenv | grep -E '^ROS_|^RMW'
ros2 doctor
```

**期待される結果:**

```
ROS_VERSION=2
ROS_PYTHON_VERSION=3
ROS_DOMAIN_ID=42
ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST
ROS_DISTRO=jazzy
RMW_IMPLEMENTATION=rmw_fastrtps_cpp
...
All 5 checks passed
```

| 行 | 意味 |
|---|---|
| `ROS_DISTRO=jazzy` | ROS 2 Jazzy が使える |
| `ROS_DOMAIN_ID=42` | 同じ番号のノード同士だけが通信する |
| `ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST` | 同じ Wi-Fi の他の PC の ROS 2 と混線しない |
| `All 5 checks passed` | 自己診断がすべて通った |

`UserWarning: ... has been updated to a new version` が大量に出るが、**無視してよい**
（新しい修正版が公開されたというお知らせで、動作には影響しない）。

✅ 2026-10-06 に実機で確認済み。

---

## Step 2 GUI が映ることを確かめる

turtlesim の前に、**「コンテナの中で開いたウィンドウがブラウザに映るか」だけ**を確かめる。
ここで映らなければ、原因は turtlesim ではなく画面の仕組みかブラウザ側にある。

### 2.1 ブラウザで接続する

1. Mac のブラウザで `http://localhost:6080/vnc.html` を開く
2. 画面中央の「**接続**」（Connect）を押す

**期待される結果:** 黒〜灰色の何もないデスクトップが表示される（まだ何も起動していないため）。

> 💡 画面の一部しか見えない場合は、左端のつまみ（▶）→ 歯車（設定）→
> 「**スケーリングモード**」を「**ローカルスケーリング**」にすると、
> 1920×1080 の画面全体がブラウザに収まる。

### 2.2 テスト用のウィンドウを出す

**ターミナル A** で実行する。

```bash
xeyes
```

**期待される結果:** ブラウザの画面に**目玉のウィンドウ**が現れ、マウスを動かすと目が追いかける。

確認できたら、ターミナル A で `Ctrl+C` を押して終了する。

| 結果 | 意味 | 次にすること |
|---|---|---|
| 目玉が映った | 画面の仕組みは正常 | Step 3 へ |
| 目玉が映らない | 画面の仕組みかブラウザ側の問題 | [8.1](#81-ブラウザに何も映らない) |
| `xeyes: command not found` | プロンプトが Mac のまま | 0.2 からやり直す |

---

## Step 3 turtlesim を起動する

### 3.1 turtlesim 本体（ターミナル A）

```bash
ros2 run turtlesim turtlesim_node
```

**期待される結果（ターミナル A）:**

```
[INFO] [...] [turtlesim]: Starting turtlesim with node name /turtlesim
[INFO] [...] [turtlesim]: Spawning turtle [turtle1] at x=[5.544445], y=[5.544445], theta=[0.000000]
```

**期待される結果（ブラウザ）:** タイトルが `TurtleSim` の、**青い背景に亀が 1 匹いる**ウィンドウが表示される。

このコマンドは終了せずに動き続ける。**ターミナル A はこのまま触らない。**

### 3.2 キー操作（ターミナル B）

```bash
ros2 run turtlesim turtle_teleop_key
```

**期待される結果（ターミナル B）:**

```
Reading from keyboard
---------------------------
Use arrow keys to move the turtle.
Use g|b|v|c|d|e|r|t keys to rotate to absolute orientations. 'f' to cancel a rotation.
'q' to quit.
```

**ターミナル B をクリックしてから**矢印キーを押す。

**期待される結果（ブラウザ）:** 亀が**白い線を描きながら**動く。

> ⚠️ キー入力を受け取るのは**ターミナル B** である。ブラウザの亀の画面をクリックしてから
> キーを押しても、亀は動かない。

---

## Step 4 ノードを観察する

**ターミナル C** で実行する。turtlesim と teleop は動かしたままにしておく。

### 4.1 起動しているノードの一覧

```bash
ros2 node list
```

**期待される結果:**

```
/teleop_turtle
/turtlesim
```

**ノード = 1 つの役割を持つプログラム**である。いま 2 つのプログラムが、
お互いの存在を自動で見つけて通信している。

### 4.2 ノードの中身を見る

```bash
ros2 node info /turtlesim
```

**期待される結果（主要な行）:**

```
/turtlesim
  Subscribers:
    /parameter_events: rcl_interfaces/msg/ParameterEvent
    /turtle1/cmd_vel: geometry_msgs/msg/Twist
  Publishers:
    /parameter_events: rcl_interfaces/msg/ParameterEvent
    /rosout: rcl_interfaces/msg/Log
    /turtle1/color_sensor: turtlesim/msg/Color
    /turtle1/pose: turtlesim/msg/Pose
  Service Servers:
    /clear: std_srvs/srv/Empty
    /kill: turtlesim/srv/Kill
    /reset: std_srvs/srv/Empty
    /spawn: turtlesim/srv/Spawn
    /turtle1/set_pen: turtlesim/srv/SetPen
    /turtle1/teleport_absolute: turtlesim/srv/TeleportAbsolute
    /turtle1/teleport_relative: turtlesim/srv/TeleportRelative
    /turtlesim/describe_parameters: ...
    （/turtlesim/ で始まるパラメータ用のサービスが続く）
  Service Clients:

  Action Servers:
    /turtle1/rotate_absolute: turtlesim/action/RotateAbsolute
  Action Clients:

```

出力の区分は、そのまま ROS 2 の通信方式の種類になっている。

| 区分 | 意味 | `/turtlesim` で注目する行 |
|---|---|---|
| Subscribers | **受け取る**トピック | `/turtle1/cmd_vel`（速度の指令） |
| Publishers | **送り出す**トピック | `/turtle1/pose`（いまの位置と向き） |
| Service Servers | 呼ばれたら**応答する**サービス | `/spawn`（亀を増やす）、`/clear`（線を消す） |
| Action Servers | **時間のかかる処理**を受け付ける | `/turtle1/rotate_absolute`（指定の向きまで回る） |

> `/parameter_events` `/rosout` と、`/turtlesim/` で始まるパラメータ用のサービスは、
> **どのノードにも自動で付く**ものである。いまは読み飛ばしてよい。

続けて teleop 側も見る。

```bash
ros2 node info /teleop_turtle
```

**期待される結果（主要な行）:**

```
/teleop_turtle
  Publishers:
    /turtle1/cmd_vel: geometry_msgs/msg/Twist
  ...
  Action Clients:
    /turtle1/rotate_absolute: turtlesim/action/RotateAbsolute
```

**ここが P01 の核心である。** `/teleop_turtle` の **Publishers** と `/turtlesim` の
**Subscribers** に、同じ `/turtle1/cmd_vel` がある。これが 2 つのノードを繋いでいる。

---

## Step 5 繋がりを図で見る

**ターミナル C** で実行する。

```bash
ros2 run rqt_graph rqt_graph
```

**期待される結果（ブラウザ）:** `rqt_graph` のウィンドウが開く。

1. 左上のプルダウンを「**Nodes/Topics (all)**」にする
2. 左上の更新ボタン（↻）を押す

**期待される結果:** 次の形の図になる。

```
/teleop_turtle  ──▶  /turtle1/cmd_vel  ──▶  /turtlesim
```

| 図の要素 | 意味 |
|---|---|
| 楕円 | ノード |
| 四角 | トピック |
| 矢印 | データの流れる向き（送り手 → 受け手） |

Step 4 で文字で見た繋がりが、図になっていることを確かめる。

> Gazebo で動かすロボットになると、ノードが 10 個以上・トピックが数十本になる。
> **この図を見て「どこが繋がっていないか」を探すのが、ROS 2 の基本のデバッグ方法**である。

---

## Step 6 繋がりを変えてみる

### 6.1 teleop を止める

1. ターミナル B で `Ctrl+C` を押して teleop を止める
2. rqt_graph の更新ボタン（↻）を押す

**期待される結果:** 図から `/teleop_turtle` と、それに繋がる矢印が消える。
**turtlesim のウィンドウはそのまま残る**（亀も消えない）。

3. ターミナル B で `ros2 run turtlesim turtle_teleop_key` を再び実行し、↻ を押す

**期待される結果:** 図に `/teleop_turtle` が戻り、再び矢印で繋がる。

### 6.2 別のノードの組を追加する

ターミナル B で teleop を `Ctrl+C` で止めてから実行する。

```bash
ros2 run demo_nodes_py talker
```

**期待される結果（ターミナル B）:** 1 秒ごとに次の行が増える。

```
[INFO] [...] [talker]: Publishing: "Hello World: 1"
[INFO] [...] [talker]: Publishing: "Hello World: 2"
```

ターミナル C で rqt_graph を閉じてから（ウィンドウの × か、ターミナル C で `Ctrl+C`）実行する。

```bash
ros2 run demo_nodes_py listener
```

**期待される結果（ターミナル C）:**

```
[INFO] [...] [listener]: I heard: [Hello World: 5]
[INFO] [...] [listener]: I heard: [Hello World: 6]
```

番号が 1 から始まらないのは、listener を起動する前に送られた分は受け取らないためである
（P07 の QoS で詳しく学ぶ）。

### 6.3 同じノードを 2 つ起動する

4 枚目のターミナルを開き（Mac で `./scripts/sh.sh`）、もう 1 つ turtlesim を起動する。

```bash
ros2 run turtlesim turtlesim_node
```

続けて、ターミナル C で listener を `Ctrl+C` で止めてから確認する。

```bash
ros2 node list
```

**期待される結果:** `/turtlesim` が **2 行**表示され、その上に次の警告が出る
（`ros2 node list` は、同じ名前のノードを見つけると必ずこの警告を出す）。

```
WARNING: Be aware that there are nodes in the graph that share an exact name, which can have unintended side effects.
```

**同じ名前のノードを 2 つ動かすと、どちらに話しかけているのか区別できなくなる。**
これを避ける方法（名前空間・リマップ）は P11 で学ぶ。

確認したら、4 枚目のターミナルで `Ctrl+C` を押して止める。

### 6.4 後片付け

各ターミナルで `Ctrl+C` を押して、動いているものをすべて止める。
コンテナは止めなくてよい（次の P02 でそのまま使う）。

---

## 到達確認

次の 4 問に答えられたら P01 は完了である。答えは[最後の章](#到達確認の答え)にある。

1. `/teleop_turtle` と `/turtlesim` は**どのトピック**で繋がっているか。どちらが送り手か。
2. `/turtlesim` が提供している**サービスを 3 つ**挙げよ（パラメータ用のものは除く）。
3. teleop を止めたとき、rqt_graph の図はどう変わったか。そのとき turtlesim のウィンドウはどうなったか。
4. 同じ名前のノードを 2 つ起動すると、何が困るか。

---

## うまくいかないとき

### 8.1 ブラウザに何も映らない

上から順に確かめる。

| # | 確認すること | 確かめ方 |
|:-:|---|---|
| 1 | URL が `/vnc.html` で終わっているか | `http://localhost:6080/vnc.html` |
| 2 | 「**接続**」ボタンを押したか | 押す前は noVNC のロゴと接続ボタンだけが表示されている |
| 3 | 画面の一部しか見えていないのではないか | 2.1 の💡（ローカルスケーリング） |
| 4 | 画面の仕組みが動いているか | Mac 側で下のコマンドを実行する |

```bash
docker exec sim_ros2_v1_ros2 bash -c 'ps aux | grep -E "Xvfb|x11vnc|websockify|fluxbox" | grep -v grep'
```

**期待される結果:** `Xvfb` `fluxbox` `x11vnc` `websockify` の 4 行が表示される。
足りない場合は、Mac で `./scripts/down.sh && ./scripts/up.sh` を実行してコンテナを作り直す。

### 8.2 xeyes は映るが、turtlesim が映らない

ターミナル A に出ているメッセージを確認する。

| ターミナル A の表示 | 原因 | 対処 |
|---|---|---|
| `Starting turtlesim ...` と `Spawning turtle ...` が出ている | 起動はしている | ウィンドウが他のウィンドウの後ろにあるか、画面外にある。2.1 の💡でスケーリングを確かめる |
| `could not connect to display` | ディスプレイの設定が無い | ターミナル A で `echo $DISPLAY` が `:1` か確かめる |
| `Package 'turtlesim' not found` | ROS 2 の設定が読み込まれていない | `source /opt/ros/jazzy/setup.bash` を実行してから再度起動する |
| `command not found: ros2` | Mac 側で実行している | プロンプトが `root@ros2:` のターミナルで実行する |

### 8.3 キーを押しても亀が動かない

- **ターミナル B をクリックしてから**キーを押しているか（ブラウザ側ではない）
- ターミナル B に `Reading from keyboard` が表示されているか
- ターミナル C で `ros2 node list` を実行し、`/teleop_turtle` が出ているか

それでも解決しない場合は、[`docs/troubleshooting.md`](../docs/troubleshooting.md) を参照する。

---

## 到達確認の答え

1. **`/turtle1/cmd_vel`** で繋がっている。送り手は **`/teleop_turtle`**（Publisher）、
   受け手は **`/turtlesim`**（Subscriber）。
2. `/clear`、`/reset`、`/spawn`、`/kill`、`/turtle1/set_pen`、`/turtle1/teleport_absolute`、
   `/turtle1/teleport_relative` のうち 3 つ。
3. 図から `/teleop_turtle` と矢印が消えた。**turtlesim のウィンドウはそのまま動き続けた。**
   ROS 2 のノードは互いに独立しており、相手がいなくなっても止まらない（疎結合）。
4. どちらのノードに話しかけているのか区別できない。指令が 2 つの両方に届いたり、
   情報を取り違えたりする。ROS 2 も警告を出す。対策は名前空間とリマップ（P11）。

---

## 変更履歴

| 日付 | 内容 |
|---|---|
| 2026-10-08 | 初版。Step 1 は実機で確認済み。Step 2 以降の「期待される結果」は turtlesim・ros2cli の Jazzy 版のソースで確認した値をもとに記載（実機での確認は未実施） |
