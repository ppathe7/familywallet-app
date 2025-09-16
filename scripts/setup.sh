#!/bin/bash

# FamilyWallet 開発環境セットアップスクリプト

set -e

echo "🚀 FamilyWallet 開発環境をセットアップします..."

# 前提条件チェック
echo "📋 前提条件をチェックしています..."

# Docker の確認
if ! command -v docker &> /dev/null; then
    echo "❌ Docker がインストールされていません。Docker をインストールしてください。"
    exit 1
fi

# Docker Compose の確認
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose がインストールされていません。Docker Compose をインストールしてください。"
    exit 1
fi

# Node.js の確認
if ! command -v node &> /dev/null; then
    echo "❌ Node.js がインストールされていません。Node.js 18+ をインストールしてください。"
    exit 1
fi

# Java の確認
if ! command -v java &> /dev/null; then
    echo "❌ Java がインストールされていません。Java 17+ をインストールしてください。"
    exit 1
fi

echo "✅ 前提条件チェック完了"

# データベースサービスの起動
echo "🗄️ データベースサービスを起動しています..."
docker-compose up -d postgres redis mailhog

# データベースの初期化待機
echo "⏳ データベースの初期化を待機しています..."
sleep 10

# バックエンドのビルド
echo "🔨 バックエンドをビルドしています..."
cd backend
./gradlew build -x test
cd ..

# フロントエンドの依存関係インストール
echo "📦 フロントエンドの依存関係をインストールしています..."
cd frontend
npm install
cd ..

# 開発環境の起動
echo "🚀 開発環境を起動しています..."
docker-compose up -d backend

echo "✅ セットアップ完了！"
echo ""
echo "📱 アクセス情報:"
echo "  - バックエンドAPI: http://localhost:8080"
echo "  - データベース: localhost:5432"
echo "  - Redis: localhost:6379"
echo "  - MailHog (メールテスト): http://localhost:8025"
echo ""
echo "🔧 開発コマンド:"
echo "  - 全サービス起動: docker-compose up -d"
echo "  - 全サービス停止: docker-compose down"
echo "  - ログ確認: docker-compose logs -f"
echo "  - フロントエンド起動: cd frontend && npm start"
echo "  - バックエンド再起動: docker-compose restart backend"
