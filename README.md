READMEを編集していません。
提案する目次
概要プロジェクトの目的
主な責務
各責務に対応するディレクトリ
主要機能一覧

クイックスタート前提環境
初回セットアップ
バックエンドとフロントエンドの一括起動
個別起動
起動確認
Streamlit版の起動

アーキテクチャ構成システム全体構成
解析データフロー
リアルタイム処理フロー
非同期ジョブと進捗通知

ディレクトリ構成backend/ — FastAPI Web API
frontend/ — React SPA
pipeline/ — ML処理コア
app/ — Streamlit版UI
その他の主要ディレクトリ

主要画面と機能解析
リアルタイム
実験管理
本番・最適化
アノテーションQA

バックエンドAPIメタ情報・ヘルスチェック
動画解析API
リアルタイムAPI
実験管理API
本番・最適化API
アノテーションQA API

MLパイプラインデバイス選択
検出・セグメンテーション
トラッキング・ゾーン解析
動画・リアルタイム処理
学習・MLflow・Model Registry
バッチ推論・モデル変換・ベンチマーク
Claude Vision・Active Learning

設定環境変数
MLflow
許可ディレクトリ
モデルとデバイス

基本ワークフロー動画解析
リアルタイム解析
学習からModel Registry登録まで
本番用バッチ推論

テストと品質確認Pythonテスト
フロントエンドテスト
Lintとビルド

制約・セキュリティ・既知の問題ローカル開発用途
M2 MacとMPS
ファイルアクセス制限
既知の問題

関連ドキュメント操作マニュアル
パイプラインIPO仕様
システム仕様・移行資料

実装Phaseと移行状況ML機能Phase 0〜6
StreamlitからReactへの移行状況

変更履歴
目次の設計理由
1. 現在の起動方法を最優先にする
現行READMEでは、旧来のStreamlit起動が先に説明されています。しかし、現在の推奨構成は次のFastAPI＋React構成です。
# 両方まとめて起動
./run_dev.sh
個別に起動する場合は、指定どおり次を掲載します。
# バックエンド：リポジトリルートで実行
uvicorn backend.app.main:app --reload --port 8000

# フロントエンド：別ターミナル
cd frontend && npm run dev
# http://localhost:5173
run_dev.sh、backend/app/main.py、docs/manual/README.mdでも、この起動方法を確認できました。Streamlit版は削除せず、「従来版・併存UI」として別項目に残します。
2. 指定フォーマットをREADME向けに採用する
a_class_method_md_format.mdは、本来PythonモジュールのIPO仕様書です。そのため、READMEにクラス・関数ごとの巨大なIPO表を直接並べるのではなく、次の規則を採用します。
概要
主な責務
責務とディレクトリの対応表
主要機能一覧
Mermaidによるアーキテクチャ図
モジュール構成と依存関係
設定・使用例
変更履歴
詳細なクラス・関数IPOは、既存の docs/ml_motion_spec.md と pipeline/docs/*.md へリンクします。これにより、指定フォーマットを踏襲しながら、READMEが過度に長いAPIリファレンスになることを防ぎます。
3. 4ディレクトリの役割を明確に分ける
コードを確認すると、現在は次の責務分担です。
ディレクトリ	READMEで説明する責務
backend/	FastAPI、REST、SSE、WebSocket、MJPEG、ジョブ管理、モデルキャッシュ、成果物管理
frontend/	React 18＋TypeScript SPA、5画面、APIクライアント、状態管理
pipeline/	検出、追跡、ゾーン解析、学習、MLflow、バッチ、変換、Claude Vision
app/	従来のStreamlit版UI。React版と同じpipeline/を利用


特に、ビジネスロジックをpipeline/に集約し、backend/を薄いHTTP層としている点を、アーキテクチャ章で明示します。
4. 既存READMEのPhase情報を維持する
既存のPhase 0〜6は削除せず、README後半の「実装Phaseと移行状況」に再編します。先頭では現在の使い方を示し、開発経緯は後から参照できる構成です。
また、現行README末尾にはP4〜P6の完了行と未完了行が重複しているため、本文作成時に実装状況と照合して一本化する必要があります。
5. 現在の5画面とAPIを反映する
React版では次の5画面がすべて実装済みです。
解析
リアルタイム
実験管理
本番・最適化
アノテーションQA
バックエンドにも、それぞれに対応するAPIルーターが存在します。READMEでは画面の利用目的を簡潔に説明し、詳細操作は既存のdocs/manual/へ誘導します。
この目次でよければ、次の段階でREADME本文を実ソースに基づいて改修します。
