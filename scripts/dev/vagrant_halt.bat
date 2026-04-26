@echo off
cd /d "%~dp0..\.."
echo === 停止 Vagrant VM ===
vagrant halt
echo.
echo VM 已停止
pause
