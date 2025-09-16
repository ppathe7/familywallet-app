# FamilyWallet 開発環境セットアップガイド

## 📋 前提条件

### 必要なソフトウェア
- **Docker & Docker Compose**: データベースとバックエンドの実行環境
- **Node.js 18+**: フロントエンド開発環境
- **Java 17+**: バックエンド開発環境
- **Android Studio / Xcode**: モバイルアプリの開発・テスト

### 推奨ツール
- **VS Code**: エディタ（Kotlin、TypeScript対応拡張機能推奨）
- **Postman**: APIテスト
- **pgAdmin**: データベース管理

## 🚀 クイックセットアップ

### 1. 自動セットアップ（推奨）
```bash
# セットアップスクリプトを実行
./scripts/setup.sh
```

### 2. 手動セットアップ

#### ステップ1: データベースサービスの起動
```bash
# PostgreSQL、Redis、MailHogを起動
docker-compose up -d postgres redis mailhog

# データベースの初期化を待機（約10秒）
sleep 10
```

#### ステップ2: バックエンドのビルド
```bash
cd backend
./gradlew build -x test
cd ..
```

#### ステップ3: フロントエンドの依存関係インストール
```bash
cd frontend
npm install
cd ..
```

#### ステップ4: 開発環境の起動
```bash
# バックエンドを起動
docker-compose up -d backend

# フロントエンドを起動（別ターミナル）
cd frontend
npm start
```

## 🔧 開発環境の詳細

### サービス構成

| サービス | ポート | 説明 |
|---------|--------|------|
| PostgreSQL | 5432 | メインデータベース |
| Redis | 6379 | キャッシュ・セッション管理 |
| MailHog | 8025 | メールテスト用WebUI |
| Backend API | 8080 | Kotlin + Spring Boot API |

### データベース接続情報

#### 本番環境
- **ホスト**: localhost:5432
- **データベース**: familywallet
- **ユーザー**: familywallet
- **パスワード**: familywallet

#### 開発環境
- **ホスト**: localhost:5432
- **データベース**: familywallet_dev
- **ユーザー**: familywallet_dev
- **パスワード**: familywallet_dev

## 📱 フロントエンド開発

### 開発サーバー起動
```bash
cd frontend
npm start
```

### プラットフォーム別実行
```bash
# Android
npm run android

# iOS
npm run ios
```

### 利用可能なスクリプト
- `npm start`: Metro bundler起動
- `npm run android`: Androidアプリ実行
- `npm run ios`: iOSアプリ実行
- `npm test`: テスト実行
- `npm run lint`: ESLint実行
- `npm run type-check`: TypeScript型チェック

## 🔨 バックエンド開発

### ローカル開発
```bash
cd backend
./gradlew bootRun
```

### Docker環境での開発
```bash
# バックエンドコンテナを起動
docker-compose up -d backend

# ログを確認
docker-compose logs -f backend

# バックエンドを再起動
docker-compose restart backend
```

### 利用可能なGradleタスク
- `./gradlew bootRun`: アプリケーション起動
- `./gradlew build`: ビルド
- `./gradlew test`: テスト実行
- `./gradlew clean`: クリーンビルド

## 🗄️ データベース管理

### データベース接続
```bash
# PostgreSQLに接続
docker exec -it familywallet-postgres psql -U postgres -d familywallet_dev
```

### データベースリセット
```bash
# コンテナを停止・削除
docker-compose down

# ボリュームも削除（データが消えます）
docker-compose down -v

# 再起動
docker-compose up -d postgres redis mailhog
```

## 🧪 テスト

### バックエンドテスト
```bash
cd backend
./gradlew test
```

### フロントエンドテスト
```bash
cd frontend
npm test
```

### 統合テスト
```bash
# 全サービスを起動
docker-compose up -d

# APIテスト（Postman等を使用）
curl http://localhost:8080/health
```

## 🐛 トラブルシューティング

### よくある問題

#### 1. ポートが既に使用されている
```bash
# 使用中のポートを確認
lsof -i :8080
lsof -i :5432
lsof -i :6379

# プロセスを終了
kill -9 <PID>
```

#### 2. Dockerコンテナが起動しない
```bash
# コンテナの状態を確認
docker-compose ps

# ログを確認
docker-compose logs <service_name>

# コンテナを再作成
docker-compose up -d --force-recreate
```

#### 3. データベース接続エラー
```bash
# データベースコンテナの状態を確認
docker-compose logs postgres

# データベースを再初期化
docker-compose down -v
docker-compose up -d postgres
```

#### 4. フロントエンドの依存関係エラー
```bash
# node_modulesを削除して再インストール
cd frontend
rm -rf node_modules package-lock.json
npm install
```

## 📚 開発ガイドライン

### コードスタイル
- **Kotlin**: Kotlin Coding Conventions に従う
- **TypeScript**: ESLint + Prettier を使用
- **コミット**: Conventional Commits に従う

### ブランチ戦略
- `main`: 本番環境
- `develop`: 開発環境
- `feature/*`: 機能開発
- `hotfix/*`: 緊急修正

### プルリクエスト
1. 機能ブランチからdevelopブランチへPR作成
2. コードレビュー実施
3. テスト通過確認
4. マージ

## 🔗 有用なリンク

- [Spring Boot 公式ドキュメント](https://spring.io/projects/spring-boot)
- [React Native 公式ドキュメント](https://reactnative.dev/)
- [PostgreSQL 公式ドキュメント](https://www.postgresql.org/docs/)
- [Docker 公式ドキュメント](https://docs.docker.com/)
