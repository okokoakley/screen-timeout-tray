@echo off
set BASE=%USERPROFILE%\PowerToggle
set SCRIPT=%BASE%\ScreenTimeoutTray.ps1
set PROMOTE=%BASE%\Promote-ScreenTimeoutTray.ps1
start "ScreenTimeoutTray" powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File "%SCRIPT%"
%SystemRoot%\System32\timeout.exe /t 3 /nobreak >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%PROMOTE%" >nul 2>nul
