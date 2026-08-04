# ROS 2 公式チュートリアル 索引

公式チュートリアルの全目次。**Python 版が存在する章を明示**し、
本プロジェクトでの扱い（対象 / 対象外 / 参考）を併記する。

| 項目 | 内容 |
|---|---|
| 取得元 | [`ros2/ros2_documentation`](https://github.com/ros2/ros2_documentation)（`humble` / `jazzy` ブランチの原本） |
| 参照先 URL | Jazzy: `https://docs.ros.org/en/jazzy/Tutorials.html` |
| 確認日 | 2026-08-04 |
| 構成差分 | Humble と Jazzy でほぼ同一（→ [`humble_jazzy_diff.md`](humble_jazzy_diff.md) 6章） |

**凡例**

| 記号 | 意味 |
|---|---|
| ✅ | 本プロジェクトの学習対象 |
| ⭕ | 参考（必要になったら読む） |
| ➖ | 対象外（C++ 専用など） |
| **(Py)** | Python 版が存在する |

---

## 目次

1. [全体構成](#1-全体構成)
2. [Beginner: CLI tools](#2-beginner-cli-tools)
3. [Beginner: Client libraries](#3-beginner-client-libraries)
4. [Intermediate](#4-intermediate)
5. [Advanced](#5-advanced)
6. [Demos](#6-demos)
7. [Miscellaneous](#7-miscellaneous)
8. [本プロジェクトの章との対応](#8-本プロジェクトの章との対応)

---

## 1. 全体構成

```
Tutorials
├── First-Steps                    前段（インストール・最初の一歩）
├── Beginner: CLI tools            10章 — CLI で概念を理解する
├── Beginner: Client libraries     13章 — コードを書く
├── Intermediate                   14章 — 実用構成（うち5つは下位に子章多数）
├── Advanced                       14章 — DDS・bag・シミュレータ・セキュリティ
├── Demos                           9章 — QoS・ライフサイクル・リアルタイム等
└── Miscellaneous                   4章 — コミュニティ寄稿
```

公式は「**上から順に進むこと**」を推奨している（各章が前章に依存するため）。

---

## 2. Beginner: CLI tools

**コードを書かずに、CLI で ROS 2 の概念を理解するセクション。**

| # | タイトル | 扱い | 本プロジェクトの章 |
|---|---|---|---|
| 1 | Configuring environment | ✅ | L01 |
| 2 | Using `turtlesim`, `ros2`, and `rqt` | ✅ | L01 |
| 3 | Understanding nodes | ✅ | L01 |
| 4 | Understanding topics | ✅ | L01 |
| 5 | Understanding services | ✅ | L02 |
| 6 | Understanding parameters | ✅ | L02 |
| 7 | Understanding actions | ✅ | L02 |
| 8 | Using `rqt_console` to view logs | ✅ | L03 |
| 9 | Launching nodes | ✅ | L03 |
| 10 | Recording and playing back data | ✅ | L03 |

---

## 3. Beginner: Client libraries

**実際にコードを書くセクション。C++ 版と Python 版が併記される。**

| # | タイトル | 扱い | 本プロジェクトの章 |
|---|---|---|---|
| 1 | Using `colcon` to build packages | ✅ | L04 |
| 2 | Creating a workspace | ✅ | L04 |
| 3 | Creating a package | ✅ | L04 |
| 4 | Writing a simple publisher and subscriber (C++) | ➖ | — |
| 5 | Writing a simple publisher and subscriber **(Py)** | ✅ | L05 |
| 6 | Writing a simple service and client (C++) | ➖ | — |
| 7 | Writing a simple service and client **(Py)** | ✅ | L06 |
| 8 | Creating custom msg and srv files | ✅ | L07 |
| 9 | Implementing custom interfaces | ✅ | L07 |
| 10 | Using parameters in a class (C++) | ➖ | — |
| 11 | Using parameters in a class **(Py)** | ✅ | L08 |
| 12 | Using `ros2doctor` to identify issues | ✅ | L08 |
| 13 | Creating and using plugins (C++) | ➖ | — |

---

## 4. Intermediate

| # | タイトル | 扱い | 本プロジェクトの章 |
|---|---|---|---|
| 1 | Managing Dependencies with rosdep | ✅ | L13 |
| 2 | Creating an action | ✅ | L09 |
| 3 | Writing an action server and client (C++) | ➖ | — |
| 4 | Writing an action server and client **(Py)** | ✅ | L09 |
| 5 | Writing a Composable Node (C++) | ➖ | — |
| 6 | Composing multiple nodes in a single process | ⭕ | — |
| 7 | Using the Node Interfaces Template Class (C++) | ➖ | — |
| 8 | Monitoring for parameter changes (C++) | ➖ | — |
| 8b | Monitoring for parameter changes **(Py)** ※Jazzy で追加 | ⭕ | — |
| 9 | **Launch**（子章 5） | ✅ | L10 |
| 10 | **tf2**（子章 14） | ✅ | L11 |
| 11 | **Testing**（子章 5） | ✅ | L13 |
| 12 | **URDF**（子章 8） | ✅ | L12 |
| 13 | **RViz**（子章 6） | ⭕ | L12（User Guide のみ） |

### 4.1 Launch の子章

| 子章 | 扱い |
|---|---|
| Creating a launch file | ✅ |
| Integrating launch files into ROS 2 packages | ✅ |
| Using substitutions | ✅ |
| Using event handlers | ✅ |
| Managing large projects | ✅ |

### 4.2 tf2 の子章

| 子章 | 扱い |
|---|---|
| Introducing `tf2` | ✅ |
| Writing a static broadcaster **(Py)** | ✅ |
| Writing a static broadcaster (C++) | ➖ |
| Writing a broadcaster **(Py)** | ✅ |
| Writing a broadcaster (C++) | ➖ |
| Writing a listener **(Py)** | ✅ |
| Writing a listener (C++) | ➖ |
| Adding a frame **(Py)** | ✅ |
| Adding a frame (C++) | ➖ |
| Using time (C++) | ⭕（概念は重要） |
| Traveling in time (C++) | ⭕ |
| Debugging | ✅ |
| Quaternion fundamentals | ✅ |
| Using stamped datatypes with `tf2_ros::MessageFilter` | ➖ |

### 4.3 Testing の子章

| 子章 | 扱い |
|---|---|
| Running Tests in ROS 2 from the Command Line | ✅ |
| Writing Basic Tests with C++ with GTest | ➖ |
| Writing Basic Tests with Python | ✅ |
| Writing Basic Integration Tests with `launch_testing` | ✅ |
| Testing Your Code with the ROS Build Farm | ⭕ |

### 4.4 URDF の子章

| 子章 | 扱い |
|---|---|
| Building a visual robot model from scratch | ✅ |
| Building a movable robot model | ✅ |
| Adding physical and collision properties | ✅ |
| Using Xacro to clean up your code | ✅ |
| **Using a URDF in Gazebo** | ✅（L14 で使用） |
| Using URDF with `robot_state_publisher` (C++) | ➖ |
| Using URDF with `robot_state_publisher` **(Py)** | ✅ |
| Generating an URDF File | ⭕ |

### 4.5 RViz の子章

| 子章 | 扱い |
|---|---|
| RViz User Guide | ✅ |
| Marker: Sending Basic Shapes (C++) | ⭕ |
| Marker: Points and Lines (C++) | ⭕ |
| Marker: Display types | ⭕ |
| Building a Custom RViz Display | ➖ |
| Building a Custom RViz Panel | ➖ |

---

## 5. Advanced

| # | タイトル | 扱い | 本プロジェクトの章 |
|---|---|---|---|
| 1 | Supplementing custom rosdep keys | ⭕ | — |
| 2 | Enabling topic statistics (C++) | ⭕ | — |
| 3 | Using Fast DDS Discovery Server as discovery protocol | ⭕ | トラブル対応時 |
| 4 | Implementing a custom memory allocator | ➖ | — |
| 5 | Ament Lint CLI Utilities | ⭕ | L13 |
| 6 | Unlocking the potential of Fast DDS middleware | ⭕ | トラブル対応時 |
| 7 | Recording a bag from a node (C++) | ➖ | — |
| 8 | Recording a bag from a node **(Py)** | ✅ | L18 |
| 9 | Reading from a bag file (C++) | ⭕ | L18（Python で実装） |
| 10 | Create an rqt_bag Plugin | ➖ | — |
| 11 | How to use `ros2_tracing` to trace and analyze | ⭕ | — |
| 12 | Creating an `rmw` implementation | ➖ | — |
| 13 | **Simulators**（Webots / **Gazebo** / MVSim） | ✅ | L14 |
| 14 | Security | ⭕ | — |

### 5.1 Simulators の子章

| 子章 | 扱い | 備考 |
|---|---|---|
| Webots | ⭕ | 代替シミュレータ。Mac ネイティブ版もある |
| **Gazebo → Setting up a robot simulation** | ✅ | **本プロジェクトの主シミュレータ。ただし Humble 版は `ign gazebo` 記法なので読み替えが必要** |
| MVSim | ➖ | 軽量 2D シミュレータ |

---

## 6. Demos

| # | タイトル | 扱い |
|---|---|---|
| 1 | Using quality-of-service settings for lossy networks | ✅（QoS 理解の補強） |
| 2 | Managing node lifecycles - example | ⭕ |
| 3 | Setting up efficient intra-process communication | ⭕ |
| 4 | Recording and playing back data with `rosbag` using the ROS 1 bridge | ➖ |
| 5 | Understanding real-time programming | ⭕ |
| 6 | Experimenting with a dummy robot | ⭕ |
| 7 | Logging | ✅ |
| 8 | Creating a content filtering subscription | ⭕ |
| 9 | Wait for acknowledgment | ⭕ |

---

## 7. Miscellaneous

| # | タイトル | 扱い |
|---|---|---|
| 1 | Deploying on IBM Cloud Kubernetes | ➖ |
| 2 | Using Eclipse Oxygen with `rviz2` | ➖ |
| 3 | Building a real-time Linux kernel | ➖ |
| 4 | Building a package with Eclipse 2021-06 | ➖ |

いずれもコミュニティ寄稿で、本プロジェクトの範囲外。

---

## 8. 本プロジェクトの章との対応

逆引き（本プロジェクトの章 → 公式チュートリアル）は
[`learning_plan.md` 4章](learning_plan.md#4-公式チュートリアル対応表) を参照。

### 8.1 公式チュートリアルでカバーされない範囲

| 本プロジェクトの章 | 内容 | 公式の状況 |
|---|---|---|
| L15 | センサ処理と制御（障害物回避） | なし |
| L16 | SLAM | なし（`slam_toolbox` の独自ドキュメント） |
| L17 | Nav2 | なし（[Nav2 公式](https://docs.nav2.org/) は別ドキュメント） |
| L18 の解析部分 | rosbag の Python 解析 | 記録・再生までは公式にあるが、解析は範囲外 |
| L19 | Web 連携 | なし |
| README 全体 | Mac / Docker / GUI / IDE | なし（Ubuntu ネイティブ前提） |

---

## 変更履歴

| 日付 | 内容 |
|---|---|
| 2026-08-04 | 初版。`ros2/ros2_documentation` の原本から目次を抽出して作成 |
