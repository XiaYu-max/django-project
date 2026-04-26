================================================================
  雲端部署
================================================================

  完整說明請見專案根目錄的 README.md

----------------------------------------------------------------
第一次部署（只需做一次）
----------------------------------------------------------------

需求
  - Linux（Ubuntu 22.04 推薦）
  - Docker：curl -fsSL https://get.docker.com | bash
  - Git

1. 安裝 Docker：
   curl -fsSL https://get.docker.com | bash
   sudo usermod -aG docker $USER && newgrp docker

2. 取得程式碼並部署：
   git clone <your-repo-url>
   cd django-project
   bash scripts/cloud/setup.sh

3. 建立後台管理員：
   cd project
   docker compose exec web python manage.py createsuperuser

開啟：http://your-server-ip/

----------------------------------------------------------------
後續更新程式碼
----------------------------------------------------------------

  git pull
  cd project
  docker compose exec web python manage.py migrate   # 如有新 migration
  docker compose restart web

----------------------------------------------------------------
常用指令速查
----------------------------------------------------------------

  cd project

  docker compose up -d             → 啟動所有容器
  docker compose down              → 停止所有容器
  docker compose ps                → 查看容器狀態
  docker compose logs -f web       → 查看 Django log
  docker compose logs -f frontend  → 查看 Vite log
  docker compose restart web       → 重啟 Django
  docker compose exec web bash     → 進入 Django 容器

  網址速查：
    http://your-server-ip/          首頁
    http://your-server-ip/admin/    Django Admin
    http://your-server-ip/api/      REST API

================================================================
