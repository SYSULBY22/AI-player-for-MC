@echo off
chcp 65001>nul
title AIMC - Pull Ollama models
echo Requires Ollama: https://ollama.com/download
echo.
where ollama >nul 2>&1
if errorlevel 1 (
    echo [ERROR] ollama not found in PATH
    pause
    exit /b 1
)

echo Pulling recommended models...
ollama pull sweaterdog/andy-4:micro-q8_0
ollama pull embeddinggemma

echo.
echo Done.
pause
