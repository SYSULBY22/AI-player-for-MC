@echo off
chcp 65001>nul
title AIMC - Start AI Player
cd /D "%~dp0mindcraft"

if not exist "node_modules\mineflayer" (
    echo [ERROR] Run install script first: ..\安装AI环境.bat
    pause
    exit /b 1
)

echo.
echo ========================================
echo   AIMC - AI Minecraft Bot
echo ========================================
echo.
echo BEFORE you press a key, make sure:
echo   [1] Minecraft is running and you are IN a world
echo   [2] Press ESC, Open to LAN, port MUST be 55916
echo   [3] Cloud API: fill DEEPSEEK_API_KEY and EMBEDDING_API_KEY in .env
echo.
echo In game chat:  /msg XiaoAi hello
echo Web panel:     http://localhost:8080
echo.
echo NOTE: "MC server not found" means LAN is NOT open on 55916.
echo       This is NOT caused by Ollama being slow.
echo.
pause

node main.js
echo.
echo AI stopped.
pause
