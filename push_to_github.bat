@echo off
cd /d "f:\SIH2026\FasalRakshak App"
echo ===================================================
echo   Pushing FasalRakshak to GitHub (AfifaKureshi)
echo ===================================================
echo.
git push -u origin main
echo.
if %ERRORLEVEL% equ 0 (
    echo ===================================================
    echo  [SUCCESS] Code pushed to GitHub successfully!
    echo.
    echo  GitHub Actions is now automatically building your
    echo  release APK in the cloud!
    echo.
    echo  Track progress & download your APK here:
    echo  https://github.com/AfifaKureshi/FasalRakshak/actions
    echo ===================================================
) else (
    echo [NOTE] If a browser window opened, click 'Authorize' to complete GitHub login and run this again.
)
pause
