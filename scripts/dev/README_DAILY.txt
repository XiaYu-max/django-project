================================================================
  開發機環境 — 日常使用
================================================================

【VM 啟動 / 停止】
  雙擊 vagrant_up.bat      → 啟動 VM
  雙擊 vagrant_halt.bat    → 停止 VM
  雙擊 vagrant_restart.bat → 重啟 VM
  雙擊 vagrant_ssh.bat     → SSH 進入 VM
  雙擊 start_dev.bat       → 啟動 VM + 重啟 Docker 容器

【Django 開發操作（VS Code）】
  Ctrl+Shift+B → 選擇任務：
    migrate（全部）         → 套用所有 migration
    makemigrations          → 建立指定模組的 migration
    migrate（指定模組）     → 只 migrate 指定模組
    restart（重啟容器）     → docker compose restart
    recreate（重建容器）    → docker compose down + up
    startmodule             → 建立新業務模組骨架
    createsuperuser         → 建立管理員帳號

【手動指令】
  ssh default "cd /home/vagrant/project && docker compose exec web python manage.py makemigrations <module>"
  ssh default "cd /home/vagrant/project && docker compose exec web python manage.py migrate"
  ssh default "cd /home/vagrant/project && docker compose restart web"

【查看 Django 即時 Log】
  VS Code → Ctrl+Shift+P → Tasks: Run Task → Django Logs

【進入容器 shell】
  ssh default "cd /home/vagrant/project && docker compose exec web bash"

【PostgreSQL 直連】
  ssh default "cd /home/vagrant/project && docker compose exec db psql -U django -d django"
  \dt     → 列出資料表
  \q      → 離開

【網址速查】
  http://localhost/          首頁
  http://localhost/login     員工登入
  http://localhost/dashboard 管理後台
  http://localhost/admin/    Django Admin

================================================================
