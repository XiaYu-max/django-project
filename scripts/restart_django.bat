@echo off
title Django 管理腳本
cd /d "%~dp0.."

:: ================================================================
:: 使用方式
::   restart_django.bat                          互動式選單
::   restart_django.bat migrate                  全部 makemigrations + migrate
::   restart_django.bat migrate <module>         指定模組 makemigrations + migrate
::   restart_django.bat makemigrations <module>  只產生指定模組 migration 檔
::   restart_django.bat rollback <module>        倒回指定模組全部 migration
::   restart_django.bat showmigrations           查看所有 migration 狀態
::   restart_django.bat startmodule <module>     建立新模組骨架
::   restart_django.bat createsuperuser          建立後台管理員
::   restart_django.bat check                    檢查設定
::   restart_django.bat restart                  重啟容器 / 套用 settings.py 變更
::   restart_django.bat recreate                 重建容器 / 套用 docker-compose.yml 變更
:: ================================================================

set MODE=%1
set ARG=%2

if "%MODE%"==""                  goto MENU
if /i "%MODE%"=="help"           goto HELP
if /i "%MODE%"=="migrate"        goto MIGRATE
if /i "%MODE%"=="makemigrations" goto MAKEMIGRATIONS
if /i "%MODE%"=="rollback"       goto ROLLBACK
if /i "%MODE%"=="showmigrations" goto SHOWMIGRATIONS
if /i "%MODE%"=="startmodule"    goto STARTMODULE
if /i "%MODE%"=="createsuperuser" goto CREATESUPERUSER
if /i "%MODE%"=="check"          goto CHECK
if /i "%MODE%"=="restart"        goto RESTART
if /i "%MODE%"=="recreate"       goto RECREATE

echo.
echo [錯誤] 不支援的模式：%MODE%
echo 請執行 restart_django.bat help 查看可用選項
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
echo  -- 資料庫 --
echo   [1] migrate          全部 makemigrations + migrate
echo   [2] showmigrations   查看 migration 狀態
echo.
echo  -- 容器 --
echo   [3] restart          重啟容器 / 套用 settings.py 變更
echo   [4] recreate         重建容器 / 套用 docker-compose.yml 變更
echo.
echo  -- 模組 / 使用者 --
echo   [5] startmodule      建立新模組骨架
echo   [6] createsuperuser  建立後台管理員
echo   [7] check            檢查設定
echo.
echo   [H] help   [Q] 離開
echo.
set /p CHOICE=請選擇操作: 

if /i "%CHOICE%"=="1" goto MIGRATE
if /i "%CHOICE%"=="2" goto SHOWMIGRATIONS
if /i "%CHOICE%"=="3" goto RESTART
if /i "%CHOICE%"=="4" goto RECREATE
if /i "%CHOICE%"=="5" goto STARTMODULE
if /i "%CHOICE%"=="6" goto CREATESUPERUSER
if /i "%CHOICE%"=="7" goto CHECK
if /i "%CHOICE%"=="H" goto HELP
if /i "%CHOICE%"=="Q" exit /b 0

echo.
echo [錯誤] 請選擇有效的選項
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
echo   restart_django.bat                          互動式選單
echo   restart_django.bat migrate                  全部 makemigrations + migrate
echo   restart_django.bat migrate ^<module^>         指定模組 makemigrations + migrate
echo   restart_django.bat makemigrations ^<module^>  只產生指定模組 migration 檔
echo   restart_django.bat rollback ^<module^>        倒回指定模組全部 migration
echo   restart_django.bat showmigrations           查看所有 migration 狀態
echo   restart_django.bat startmodule ^<module^>     建立新模組骨架
echo   restart_django.bat createsuperuser          建立後台管理員
echo   restart_django.bat check                    檢查設定
echo   restart_django.bat restart                  重啟容器
echo   restart_django.bat recreate                 重建容器
echo.
pause
goto MENU

:: ================================================================
:MIGRATE
:: ================================================================
echo.
if "%ARG%"=="" (
    echo ================================================================
    echo   migrate - 全部 makemigrations + migrate
    echo ================================================================
    echo.
    ssh default "cd /home/vagrant/project && docker compose exec web python manage.py makemigrations"
) else (
    echo ================================================================
    echo   migrate %ARG% - 指定模組 makemigrations + migrate
    echo ================================================================
    echo.
    ssh default "cd /home/vagrant/project && docker compose exec web python manage.py makemigrations %ARG%"
)
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] makemigrations 失敗！
    echo 提示：請確認 VM 是否啟動，或執行 vagrant_up.bat
    pause
    exit /b 1
)
echo.
if "%ARG%"=="" (
    ssh default "cd /home/vagrant/project && docker compose exec web python manage.py migrate"
) else (
    ssh default "cd /home/vagrant/project && docker compose exec web python manage.py migrate %ARG%"
)
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] migrate 失敗！
    pause
    exit /b 1
)
echo.
echo ================================================================
echo   完成！Django 管理介面 http://localhost:8000
echo ================================================================
pause
exit /b 0

:: ================================================================
:MAKEMIGRATIONS
:: ================================================================
echo.
if "%ARG%"=="" (
    echo [錯誤] 請指定模組名稱，例如：restart_django.bat makemigrations pos_menu
    pause
    exit /b 1
)
echo ================================================================
echo   makemigrations %ARG% - 只產生指定模組 migration 檔
echo ================================================================
echo.
ssh default "cd /home/vagrant/project && docker compose exec web python manage.py makemigrations %ARG%"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] makemigrations 失敗！
    pause
    exit /b 1
)
echo.
echo ================================================================
echo   完成！migration 檔已產生，請執行 migrate 套用
echo ================================================================
pause
exit /b 0

:: ================================================================
:ROLLBACK
:: ================================================================
echo.
if "%ARG%"=="" (
    echo [錯誤] 請指定模組名稱，例如：restart_django.bat rollback pos_menu
    pause
    exit /b 1
)
echo ================================================================
echo   rollback %ARG% - 倒回指定模組全部 migration
echo ================================================================
echo.
echo [警告] 此操作將刪除 %ARG% 的所有資料表！
set /p CONFIRM=確認繼續？(y/N): 
if /i not "%CONFIRM%"=="y" (
    echo 已取消
    pause
    exit /b 0
)
ssh default "cd /home/vagrant/project && docker compose exec web python manage.py migrate %ARG% zero"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] rollback 失敗！
    pause
    exit /b 1
)
echo.
echo ================================================================
echo   完成！%ARG% 已倒回全部 migration
echo ================================================================
pause
exit /b 0

:: ================================================================
:SHOWMIGRATIONS
:: ================================================================
echo.
echo ================================================================
echo   showmigrations - 查看所有 migration 狀態
echo ================================================================
echo.
ssh default "cd /home/vagrant/project && docker compose exec web python manage.py showmigrations"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] showmigrations 失敗！
    pause
    exit /b 1
)
echo.
pause
exit /b 0

:: ================================================================
:STARTMODULE
:: ================================================================
echo.
if "%ARG%"=="" (
    echo [錯誤] 請指定模組名稱，例如：restart_django.bat startmodule pos_order
    pause
    exit /b 1
)
echo ================================================================
echo   startmodule %ARG% - 建立新模組骨架
echo ================================================================
echo.
ssh default "cd /home/vagrant/project && docker compose exec web python manage.py startmodule %ARG%"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] startmodule 失敗！
    pause
    exit /b 1
)
echo.
echo ================================================================
echo   完成！modules/%ARG%/ 骨架已建立
echo ================================================================
pause
exit /b 0

:: ================================================================
:CREATESUPERUSER
:: ================================================================
echo.
echo ================================================================
echo   createsuperuser - 建立後台管理員
echo ================================================================
echo.
ssh default -t "cd /home/vagrant/project && docker compose exec web python manage.py createsuperuser"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] createsuperuser 失敗！
    pause
    exit /b 1
)
echo.
pause
exit /b 0

:: ================================================================
:CHECK
:: ================================================================
echo.
echo ================================================================
echo   check - 檢查 Django 設定
echo ================================================================
echo.
ssh default "cd /home/vagrant/project && docker compose exec web python manage.py check"
if %errorlevel% neq 0 (
    echo.
    echo [錯誤] check 發現問題！
    pause
    exit /b 1
)
echo.
echo ================================================================
echo   設定檢查通過！
echo ================================================================
pause
exit /b 0

:: ================================================================
:RESTART
:: ================================================================
echo.
echo ================================================================
echo   restart - 重啟容器 / 套用 settings.py 變更
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
