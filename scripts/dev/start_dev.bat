@echo off
title Django Dev Environment
cd /d "%~dp0..\.."

echo ========================================
echo   Starting Vagrant VM...
echo ========================================
vagrant up

echo.
echo ========================================
echo   Restarting Docker containers...
echo ========================================
vagrant ssh -c "cd /home/vagrant/project && docker compose down && docker compose up -d"

echo.
echo ========================================
echo   Done! http://localhost
echo ========================================
pause
