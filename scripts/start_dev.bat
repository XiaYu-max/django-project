@echo off
title Django Dev Environment
cd /d "%~dp0.."

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
echo   Done! Django: http://localhost:8000
echo ========================================
pause

@REM echo.
@REM echo ========================================
@REM echo   Opening VS Code Remote SSH...
@REM echo ========================================
@REM code --remote ssh-remote+default /home/vagrant/project

@REM echo.
@REM echo ========================================
@REM echo   Done! VS Code is connecting to VM.
@REM echo   Django: http://localhost:8000
@REM echo   Debug port: 5678
@REM echo ========================================
@REM pause
