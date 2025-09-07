@echo off
setlocal
pushd "%~dp0.."

echo Generating Prometheus config for external app (Windows host IP) ...
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\resolve-windows-host-ip.ps1" || goto :end

echo Starting stack without app container ...
podman-compose up -d

:end
set ERR=%ERRORLEVEL%
popd
echo.
pause
exit /b %ERR%
