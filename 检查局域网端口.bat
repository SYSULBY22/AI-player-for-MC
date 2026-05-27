@echo off
chcp 65001>nul
title Check Minecraft LAN port 55916
echo Testing 127.0.0.1:55916 ...
echo.
powershell -NoProfile -Command "try { $t=New-Object Net.Sockets.TcpClient; $t.Connect('127.0.0.1',55916); $t.Close(); Write-Host '[OK] Port 55916 is open - you can start AI now.' -ForegroundColor Green } catch { Write-Host '[FAIL] Port 55916 is closed.' -ForegroundColor Red; Write-Host 'Fix: In Minecraft ESC - Open to LAN - set port to 55916' }"
echo.
pause
