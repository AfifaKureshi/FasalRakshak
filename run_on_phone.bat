@echo off
setlocal enabledelayedexpansion
title FasalRakshak Mobile Server

echo ================================================================
echo      FASALRAKSHAK: SERVING HIGH-SPEED PRODUCTION APP TO PHONE
echo ================================================================
echo.

:: Detect current active IPv4 address automatically
for /f "tokens=*" %%i in ('powershell -Command "Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike '*Loopback*' -and $_.IPAddress -notlike '169.254*' } | Select-Object -ExpandProperty IPAddress | Select-Object -First 1"') do (
    set LOCAL_IP=%%i
)

if "%LOCAL_IP%"=="" set LOCAL_IP=10.14.140.107

echo Detected Laptop IP: %LOCAL_IP%
echo.
echo 1. Starting FasalRakshak Unified Production Server (Port 8000)...
start "FasalRakshak Unified Server" cmd /k "cd backend && python run.py"

echo.
echo ================================================================
echo   [METHOD 1: LOCAL HOTSPOT / WI-FI (FASTEST)]
echo.
echo   Open this URL in Chrome / Safari on your phone:
echo.
echo         http://%LOCAL_IP%:8000
echo.
echo   (Make sure your phone is connected to this laptop's hotspot
echo    or the same Wi-Fi network)
echo ================================================================
echo.
echo   [METHOD 2: PUBLIC HTTPS TUNNEL (BEST FOR PHONE CAMERA/MIC)]
echo.
echo   If your phone hotspot blocks local ports or you need HTTPS
echo   for full Camera & Voice mic permissions, press 'T' below
echo   to generate an instant secure HTTPS link for your phone!
echo ================================================================
echo.
set /p CHOICE="Type 'T' to launch HTTPS Tunnel, or press Enter to keep local: "

if /i "%CHOICE%"=="T" (
    echo.
    echo Launching secure, passwordless HTTPS tunnel on port 8000...
    echo In a few seconds, a new window will show your public HTTPS link and QR code!
    start "FasalRakshak HTTPS Tunnel" cmd /k "ssh -o StrictHostKeyChecking=no -R 80:localhost:8000 nokey@localhost.run"
)

echo.
echo Ready! Keep this window open while testing.
pause
