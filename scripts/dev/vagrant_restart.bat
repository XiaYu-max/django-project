@echo off
cd /d "%~dp0..\.."
echo === 重啟 Vagrant VM ===
vagrant reload
echo.
echo VM 已重啟
pause
