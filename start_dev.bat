@echo off
title Django Dev Environment
cd /d "%~dp0"

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
echo   Opening VS Code Remote SSH...
echo ========================================
code --remote ssh-remote+default /home/vagrant/project

echo.
echo ========================================
echo   Done! VS Code is connecting to VM.
echo   Django: http://localhost:8000
echo   Debug port: 5678
echo ========================================
pause
