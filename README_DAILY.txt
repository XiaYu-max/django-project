# Django + PostgreSQL Docker Vagrant 環境 - 日常使用指南

## 啟動 / 停止 VM
vagrant up       # 啟動 VM + Docker daemon + container
vagrant ssh      # 進入 VM
vagrant halt     # 停止 VM

## Docker 管理
docker ps                   # 查看正在運行的 container
docker compose up -d         # 啟動 container
docker compose down          # 停止 container
docker compose logs -f       # 查看 container 日誌

## Django 開發操作
docker compose exec web bash  # 進入 web container
cd /app                       # 專案資料夾
python manage.py makemigrations  # 建立 migration
python manage.py migrate         # 套用資料表
python manage.py createsuperuser # 建立 superuser
python manage.py runserver 0.0.0.0:8000  # 啟動開發伺服器

## PostgreSQL 使用
docker compose exec db psql -U django -d django  # 進入資料庫
\dt   # 檢查資料表
\q    # 離開 psql

## 注意事項
- bootstrap.sh 設計為第一次運行自動安裝，之後不會重建專案或資料庫
- 若需要重置 Django 專案或 PostgreSQL 資料庫：
  1. 停止 VM：`vagrant halt`
  2. 刪除 `/home/vagrant/project` 或 Docker volumes
  3. 再次 `vagrant up` 重新建立環境
- 日常開發流程：先啟動 VM → 確認 Docker container → 執行 Django migrate / runserver