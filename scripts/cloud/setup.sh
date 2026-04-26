#!/bin/bash
# setup.sh — 雲端新機器快速部署腳本
# 用法：bash scripts/cloud/setup.sh
# 需求：已安裝 Docker、Docker Compose、git

set -e

# 切到專案根目錄（project/）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/../../project"

echo "=== POS 點餐平台 — 雲端環境建置 ==="

# 確認 Docker 存在
if ! command -v docker &> /dev/null; then
    echo "[錯誤] 找不到 Docker，請先安裝 Docker"
    echo "  Ubuntu: curl -fsSL https://get.docker.com | bash"
    exit 1
fi

cd "$PROJECT_DIR"
echo "工作目錄：$PROJECT_DIR"

# 啟動容器（自動安裝 requirements.txt）
echo ""
echo "[1/3] 啟動容器..."
docker compose up -d

# 等待 web 容器 pip install 完成（等到 Django 開始監聽才繼續）
echo ""
echo "[2/3] 等待 Django 服務就緒..."
for i in $(seq 1 60); do
    if docker compose logs web 2>/dev/null | grep -q "Starting development server"; then
        echo "Django 就緒（等了約 ${i} 秒）"
        break
    fi
    sleep 3
done

# 套用 migration
echo ""
echo "[3/3] 套用資料庫 migration..."
docker compose exec web python manage.py migrate

echo ""
echo "=== 完成 ==="
echo "網站入口（nginx）：http://your-server-ip"
echo "Django API：       http://your-server-ip/api/"
echo "Django Admin：     http://your-server-ip/admin/"
echo "取得 Token：       POST http://your-server-ip/api/auth/token/"
echo ""
echo "建立後台管理員："
echo "  docker compose exec web python manage.py createsuperuser"
