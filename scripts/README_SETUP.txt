# Django + PostgreSQL Docker Vagrant 環境 - 安裝與驗證

## 預備工作
1. 安裝 Vagrant: https://www.vagrantup.com/downloads
2. 安裝 VirtualBox: https://www.virtualbox.org/wiki/Downloads
3. 將 bootstrap.sh 與 Vagrantfile 放在同一資料夾

---

## 第一次建立環境
1. 打開 terminal 進入資料夾
2. 執行：
   vagrant up
   # bootstrap.sh 會自動：
   # - 安裝官方 Docker + Docker Compose plugin
   # - 啟動 Docker daemon
   # - 建立專案資料夾 /home/vagrant/project
   # - 建立 docker-compose.yml
   # - 啟動 Django + PostgreSQL container

3. SSH 進入 VM：
   vagrant ssh

---

## 驗證安裝是否成功

### 系統服務檢查
sudo systemctl status docker
# 預期看到 active (running)

### Docker / Container
docker ps
# 預期看到 'db' 與 'web' container 都在 RUNNING

### Django 專案檢查
docker compose exec web bash
ls /app/manage.py
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver 0.0.0.0:8000
# 開瀏覽器 http://localhost:8000，應該看到 Django 歡迎頁

### PostgreSQL 檢查
docker compose exec db psql -U django -d django
\dt   # 檢查資料表
\q    # 離開