@echo off
title Django 管理腳本
cd /d "%~dp0.."

:: ================================================================
:: 使用方式
::   restart_django.bat help     顯示幫助訊息
::   restart_django.bat migrate  套用資料表變更
::   restart_django.bat restart  重啟容器 / 套用 settings.py 變更
::   restart_django.bat recreate 重建容器 / 套用 docker-compose.yml 變更
:: ================================================================

set MODE=%1

if "%MODE%"==""         goto MENU
if /i "%MODE%"=="help"     goto HELP
if /i "%MODE%"=="migrate"  goto MIGRATE
if /i "%MODE%"=="restart"  goto RESTART
if /i "%MODE%"=="recreate" goto RECREATE

echo.
echo [錯誤] 不支援的模式：%MODE%
echo 請選擇 restart_django.bat help 查看可用選項
echo.
pause
exit /b 1

:: ================================================================
:MENU
:: ================================================================
cls
echo ================================================================
echo   Django 管理腳本 - 請選擇操作
echo ================================================================
echo.
echo   [1] migrate  套用資料表變更 (makemigrations + migrate)
echo   [2] restart  重啟容器 / 套用 settings.py 變更
echo   [3] recreate 重建容器 / 套用 docker-compose.yml 變更
echo   [H] help     顯示幫助訊息
echo   [Q] 離開
echo.
set /p CHOICE=請選擇操作: 

if /i "%CHOICE%"=="1" goto MIGRATE
if /i "%CHOICE%"=="2" goto RESTART
if /i "%CHOICE%"=="3" goto RECREATE
if /i "%CHOICE%"=="H" goto HELP
if /i "%CHOICE%"=="Q" exit /b 0

echo.
echo [錯誤] 請選擇有效的操作：1、2、3、H 或 Q
pause
goto MENU

:: ================================================================
:HELP
:: ================================================================
cls
echo ================================================================
echo   Django 管理腳本 - 幫助訊息
echo ================================================================
echo.
echo   此腳本用於管理 Django 專案，包括重新載入 .py 檔案變更。
echo.
echo   功能說明：
echo   models.py                  套用資料表變更 (makemigrations + migrate)
echo   HTML / template             套用模板變更
echo   settings.py                 重啟容器 / 套用設定變更

echo   docker-compose.yml          套用 docker-compose.yml 變更
echo   Container / settings.py     套用容器 / 設定變更
echo.
echo ================================================================
echo.
pause
goto MENU

:: ================================================================
:MIGRATE
:: ================================================================
echo.
echo ================================================================
echo   [1] migrate - 套用資料表變更 (makemigrations + migrate)
echo   套用 models.py 變更
echo ================================================================
echo.
ssh default "cd /home/vagrant/project && docker compose exec web python manage.py makemigrations"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] makemigrations 失敗！
    echo 提示：請確認 VM 是否啟動，或執行 vagrant_up.bat
    pause
    exit /b 1
)
echo.
ssh default "cd /home/vagrant/project && docker compose exec web python manage.py migrate"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] migrate 失敗！
    pause
    exit /b 1
)
echo.
echo ================================================================
echo   [1] migrate - 套用資料表變更 (makemigrations + migrate)
echo   套用 models.py 變更
echo   [2] restart - 重啟容器 / 套用 settings.py 變更
echo   Django 管理介面 http://localhost:8000
echo ================================================================
pause
exit /b 0

:: ================================================================
:RESTART
:: ================================================================
echo.
echo ================================================================
echo   [2] restart - 重啟容器 / 套用 settings.py 變更
echo ================================================================
echo.
ssh default "cd /home/vagrant/project && docker compose restart web"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] restart 失敗！
    echo 提示：請確認 VM 是否啟動，或執行 vagrant_up.bat
    pause
    exit /b 1
)
echo.
echo --- 容器狀態 ---
ssh default "cd /home/vagrant/project && docker compose ps"
echo.
echo --- 最新 40 行日誌 ---
ssh default "cd /home/vagrant/project && docker compose logs --tail=40 web"
echo.
echo ================================================================
echo   Django 管理介面 http://localhost:8000
echo ================================================================
pause
exit /b 0

:: ================================================================
:RECREATE
:: ================================================================
echo.
echo ================================================================
echo   [3] recreate - 重新建立容器 (down + up -d)
echo   套用 docker-compose.yml 變更
echo   套用容器 / 設定變更
echo ================================================================
echo.
ssh default "cd /home/vagrant/project && docker compose down"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] down 失敗！
    pause
    exit /b 1
)
echo.
ssh default "cd /home/vagrant/project && docker compose up -d"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] up 失敗！
    pause
    exit /b 1
)
echo.
echo --- 容器狀態 ---
ssh default "cd /home/vagrant/project && docker compose ps"
echo.
echo --- 最新 40 行日誌 ---
ssh default "cd /home/vagrant/project && docker compose logs --tail=40 web"
echo.
echo ================================================================
echo   Django 管理介面 http://localhost:8000
echo ================================================================
pause
exit /b 0
