#!/bin/bash

# FamilyWallet 開発環境起動スクリプト

set -e

echo "🚀 FamilyWallet 開発環境を起動します..."

# 全サービスを起動
echo "📦 全サービスを起動しています..."
docker-compose up -d

# サービスの起動を待機
echo "⏳ サービスの起動を待機しています..."
sleep 5

# サービス状態を確認
echo "📊 サービス状態を確認しています..."
docker-compose ps

echo "✅ 開発環境が起動しました！"
echo ""
echo "📱 アクセス情報:"
echo "  - バックエンドAPI: http://localhost:8080"
echo "  - データベース: localhost:5432"
echo "  - Redis: localhost:6379"
echo "  - MailHog: http://localhost:8025"
echo ""
echo "🔧 次のステップ:"
echo "  1. フロントエンドを起動: cd frontend && npm start"
echo "  2. モバイルアプリを起動: npm run android または npm run ios"
echo ""
echo "📋 便利なコマンド:"
echo "  - ログ確認: docker-compose logs -f"
echo "  - サービス停止: docker-compose down"
echo "  - バックエンド再起動: docker-compose restart backend"
