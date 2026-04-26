@echo off
cd /d "%~dp0..\.."
echo === 啟動 Vagrant VM ===
vagrant up
echo.
echo VM 已啟動，Django: http://localhost:8000
pause
