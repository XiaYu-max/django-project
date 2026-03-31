@echo off
title Django Restart
cd /d "%~dp0"
echo Restarting Django (web container)...
ssh default "cd /home/vagrant/project && docker compose restart web"
echo.
echo Waiting for Django to start (~20s)...
timeout /t 25 /nobreak >nul
echo Done! Django: http://localhost:8000
pause
