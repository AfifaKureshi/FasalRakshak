@echo off
echo ===================================================
echo     FASALRAKSHAK: STARTING PROTOTYPE ECOSYSTEM
echo ===================================================
echo.

echo 1. Starting FastAPI Backend on port 8000...
start "FasalRakshak Backend (FastAPI)" cmd /k "cd backend && python run.py"

echo 2. Launching Flutter Application...
start "FasalRakshak Mobile App (Flutter)" cmd /k "cd mobile && D:\SDKs\flutter\bin\flutter.bat run -d chrome"

echo.
echo ===================================================
echo System is launching!
echo FastAPI docs: http://127.0.0.1:8000/docs
echo ===================================================
