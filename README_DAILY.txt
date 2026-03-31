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

================================================================================
VS Code 日常開發操作流程
================================================================================

【一、啟動開發環境】
  方法 A：一鍵啟動
    雙擊 start_dev.bat → 自動啟動 VM + Docker + VS Code Remote SSH

  方法 B：手動啟動
    1. 雙擊 vagrant_up.bat（啟動虛擬機）
    2. VS Code 裡 Ctrl+Shift+P → Remote-SSH: Connect to Host → 選 default
    3. 在 VM 裡開啟 /home/vagrant/project

【二、查看 Django 運行狀態（即時 Log）】
  Ctrl+Shift+P → Tasks: Run Task → 選擇：
    - Django Logs        → 只看 Django（web 容器）的即時 log
    - Django Logs (All)  → 看所有容器（Django + PostgreSQL）的 log
  按 Ctrl+C 停止查看

【三、修改程式碼後重啟 Django】
  Ctrl+Shift+B → 自動重啟 Django 容器（約 25 秒）
  ※ 因為使用 debugpy + --noreload，Django 不會自動偵測檔案變更
  ※ 每次改完程式碼都要 Ctrl+Shift+B 重啟

【四、Debug 斷點除錯】
  1. 打開要除錯的 Python 檔案，點行號左邊放紅色斷點
  2. 按 F5（或 Debug 面板 → 選 "Django: Remote Debug (Docker in Vagrant)" → 綠色播放）
  3. 瀏覽器操作觸發該程式碼（例如 http://localhost:8000/health/）
  4. VS Code 會暫停在斷點，左邊面板可查看變數
  ※ 測試用 URL：http://localhost:8000/health/ → 命中 project/config/urls.py 第 22 行
  ※ 每次 Ctrl+Shift+B 重啟後需要重新按 F5 attach debugger

【五、常用快捷鍵一覽】
  Ctrl+Shift+B        → 重啟 Django
  F5                   → Attach Debugger
  Ctrl+Shift+P        → 命令面板（搜尋 Tasks / Remote-SSH 等）
  Ctrl+C（Terminal）   → 停止 log 查看

【六、停止開發環境】
  雙擊 vagrant_halt.bat → 停止虛擬機（所有容器一起停）

【七、檔案說明】
  start_dev.bat        → 一鍵啟動 VM + Docker + VS Code Remote
  restart_django.bat   → 一鍵重啟 Django（也可在 VS Code 外使用）
  vagrant_up.bat       → 啟動 VM
  vagrant_halt.bat     → 停止 VM
  vagrant_ssh.bat      → SSH 進入 VM
  vagrant_status.bat   → 查看 VM 狀態
  vagrant_restart.bat  → 重啟 VM