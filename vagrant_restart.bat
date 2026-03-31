@echo off
cd /d "%~dp0"
echo === 重啟 Vagrant VM ===
vagrant halt
vagrant up
echo.
echo VM 已重啟
pause
