# Render早期デプロイ手順

## 目的

MVP開発の早い段階で本番環境へデプロイし、開発環境と本番環境の差分によるエラーに早めに気づける状態にします。

## デプロイ構成

- Render Blueprint: `render.yaml`
- Web Service: Docker Runtime
- Database: Render PostgreSQL
- デプロイ対象ブランチ: `main`

## Renderで設定する環境変数

`render.yaml` で以下を定義しています。

- `DATABASE_URL`: Render PostgreSQLから自動設定
- `RAILS_MASTER_KEY`: Render作成時に手動入力
- `RAILS_LOG_LEVEL`: `info`
- `RAILS_MAX_THREADS`: `3`

`RAILS_MASTER_KEY` には、ローカルの `config/master.key` の値を設定します。この値は秘密情報なので、GitHubにはコミットしません。

## 手動作業

1. RenderのDashboardを開く
2. `New` から `Blueprint` を選択する
3. GitHubリポジトリ `ringowasabi/-graduation_app` を選択する
4. Blueprint fileに `render.yaml` が選ばれていることを確認する
5. `RAILS_MASTER_KEY` に `config/master.key` の値を入力する
6. 作成後、初回デプロイが成功することを確認する

## 動作確認

- RenderのService URLにアクセスし、トップページが表示される
- RenderのログにDB接続エラーが出ていない
- `/up` にアクセスし、ヘルスチェックが成功する

## 注意

Renderのプランや無料枠の状況によって、作成画面でプラン変更が必要になる場合があります。その場合は、画面上で選択できる最小のプランを選びます。
