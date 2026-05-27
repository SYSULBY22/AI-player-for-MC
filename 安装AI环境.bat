@echo off
chcp 65001>nul
title AIMC - Install AI
cd /D "%~dp0"

if not exist "mindcraft\package.json" (
    echo Cloning Mindcraft...
    git clone --depth 1 https://github.com/mindcraft-bots/mindcraft.git
    if errorlevel 1 (
        echo [ERROR] git clone failed
        pause
        exit /b 1
    )
)

cd mindcraft
echo Installing npm packages, may take 5-15 min...
call npm install
if errorlevel 1 (
    echo [ERROR] npm install failed. Try Node 20 LTS.
    pause
    exit /b 1
)

cd ..
if not exist ".env" (
    if exist ".env.example" (
        copy /Y ".env.example" ".env" >nul
        echo Created .env from .env.example - edit it and add your API keys for cloud mode.
    )
)
cd mindcraft

echo.
echo Done. Next: copy .env.example to .env if using cloud API, open MC LAN port 55916, run 启动AI玩家.bat
echo.
pause
