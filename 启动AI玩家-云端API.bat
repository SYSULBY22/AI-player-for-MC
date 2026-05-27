@echo off
chcp 65001>nul
title AIMC - Cloud API (DeepSeek + DashScope)
cd /D "%~dp0mindcraft"

if not exist "node_modules\mineflayer" (
    echo [ERROR] Run ..\安装AI环境.bat first
    pause
    exit /b 1
)

if not exist "..\.env" (
    echo [ERROR] Missing .env in project root
    echo   Copy .env.example to .env and set DEEPSEEK_API_KEY and EMBEDDING_API_KEY
    pause
    exit /b 1
)

echo.
echo Cloud API mode - no Ollama needed
echo   Chat:      DeepSeek deepseek-chat
echo   Embedding: Aliyun text-embedding-v3
echo.
echo [1] Minecraft world open to LAN port 55916
echo [2] In game: /msg XiaoAi hello
echo.
pause

node main.js
pause
