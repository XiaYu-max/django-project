================================================================
  開發機環境 — 第一次安裝
================================================================

  完整安裝步驟請見專案根目錄的 README.md
  （包含 Vagrant / VirtualBox 安裝、git clone、容器啟動）

----------------------------------------------------------------
快速流程（已安裝 Vagrant + VirtualBox）
----------------------------------------------------------------

  1. vagrant up
  2. ssh default "cd /home/vagrant/project && docker compose up -d"
  3. VS Code Ctrl+Shift+B → Django: migrate（全部）
  4. ssh default "cd /home/vagrant/project && docker compose exec web python manage.py createsuperuser"
  5. 開啟 http://localhost/

----------------------------------------------------------------
驗證安裝是否成功
----------------------------------------------------------------

  瀏覽器開啟 http://localhost/
  API 測試：POST http://localhost/api/auth/token/
    Body: { "username": "...", "password": "..." }

  容器狀態：
    ssh default "cd /home/vagrant/project && docker compose ps"

================================================================
