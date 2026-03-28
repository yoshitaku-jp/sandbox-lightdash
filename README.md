# sandbox-lightdash

Lightdash を試すためのローカルサンドボックス環境。
プレミアリーグ 2024-25 シーズンのサンプルデータを使って、Lightdash 上でデータ探索やダッシュボード作成を体験できる。

## 構成

```
Lightdash(:8080) ──▶ PostgreSQL(:5432) ◀── dbt(uv)
                          ▲
MinIO(:9000) ◀── S3互換ストレージ(クエリ結果保存)
```

| サービス | 用途 |
|---------|------|
| PostgreSQL | メタデータストア + データウェアハウス |
| MinIO | クエリ結果のページネーション用 S3 互換ストレージ |
| Lightdash | BI ツール本体 |
| dbt (uv管理) | モデル定義・データ投入 |

## 前提条件

- Docker Desktop
- uv
- Apple Silicon Mac: Docker Desktop > Settings > General > 「Use Rosetta for x86_64/amd64 emulation on Apple Silicon」を有効にする

## セットアップ

```bash
./setup.sh
```

以下が自動実行される:
1. Docker Compose で全コンテナ起動（Lightdash, PostgreSQL, MinIO）
2. ユーザー登録・組織作成・プロジェクト作成
3. `dbt seed` & `dbt run` でサンプルデータ投入・モデル構築
4. `lightdash deploy` で Explore をデプロイ
5. チャート・ダッシュボードをアップロード

完了後 http://localhost:8080 にアクセス:

| 項目 | 値 |
|------|-----|
| Email | `admin@example.com` |
| Password | `Password1!` |

## データモデル

プレミアリーグ 2024-25 シーズン前半のサンプルデータ。

| seed | 内容 | 件数 |
|------|------|------|
| `raw_teams` | 全20チーム | 20 |
| `raw_players` | 主要選手 | 40 |
| `raw_matches` | 試合結果（MD1〜11） | 50 |
| `raw_goals` | 得点記録 | 132 |

| マート | 内容 |
|--------|------|
| `team_standings` | 順位表（勝ち点・得失点差） |
| `player_stats` | 選手別得点ランキング |

## Lightdash コンテンツ

`lightdash/` 配下に as-code で管理:

| 種類 | 名前 |
|------|------|
| チャート | 勝ち点ランキング、得点ランキング TOP10、チーム別 得点 vs 失点、国籍別ゴール数 |
| ダッシュボード | プレミアリーグ ダッシュボード |

## 停止

```bash
docker compose down      # コンテナ停止
docker compose down -v   # データも削除（完全リセット）
```
