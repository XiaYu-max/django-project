#!/usr/bin/env bash
set -e

echo "🚀 更新系統..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "📦 安裝必要套件..."
sudo apt-get install -y \
    ca-certificates curl gnupg lsb-release

# 安裝官方 Docker
if ! command -v docker &> /dev/null; then
    echo "🐳 安裝官方 Docker..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# 啟動 Docker 服務
echo "🐳 啟動 Docker daemon..."
sudo systemctl enable docker
sudo systemctl start docker

# 將 vagrant 使用者加入 docker 群組
sudo usermod -aG docker vagrant || true

# 建立專案資料夾
PROJECT_DIR="/home/vagrant/project"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# 建立 docker-compose.yml（第一次用才建）
if [ ! -f "docker-compose.yml" ]; then
    cat > docker-compose.yml <<'EOF'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: django
      POSTGRES_USER: django
      POSTGRES_PASSWORD: django
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  web:
    image: python:3.11
    command: >
      bash -c '
      if [ ! -f /app/manage.py ]; then
        pip install --upgrade pip &&
        pip install django psycopg2-binary &&
        django-admin startproject config /app;
      fi &&
      cd /app &&
      python manage.py runserver 0.0.0.0:8000
      '
    volumes:
      - .:/app
    working_dir: /app
    ports:
      - "8000:8000"
    depends_on:
      - db

volumes:
  postgres_data:
EOF
fi

# 啟動 docker-compose
echo "🚀 啟動 Docker Compose 服務..."
docker compose up -d || echo "⚠️ 注意：可能需要重新登入 vagrant 以套用 docker 群組權限"

echo "✅ Bootstrap 完成！"
echo "Django 網頁：http://localhost:8000"
echo "PostgreSQL：127.0.0.1:5432 (user: django / password: django / db: django)"