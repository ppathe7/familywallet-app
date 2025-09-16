# FamilyWallet 家計簿アプリ

夫婦・カップル・家族向けのスマート家計管理アプリです。

## 🏗️ プロジェクト構成

```
familywallet-app/
├── backend/          # Kotlin + Spring Boot バックエンド
├── frontend/         # React Native + TypeScript フロントエンド
├── database/         # PostgreSQL データベース設定
├── docker/           # Docker 設定ファイル
├── docs/             # ドキュメント
└── scripts/          # 開発用スクリプト
```

## 🚀 クイックスタート

### 前提条件
- Docker & Docker Compose
- Node.js 18+
- Java 17+
- Android Studio / Xcode (モバイル開発用)

### 開発環境起動
```bash
# 全サービスを起動
docker-compose up -d

# バックエンド開発サーバー起動
cd backend && ./gradlew bootRun

# フロントエンド開発サーバー起動
cd frontend && npm start
```

## 📚 詳細ドキュメント
- [開発環境セットアップ](./docs/setup.md)
- [API仕様書](./docs/api.md)
- [データベース設計](./docs/database.md)
