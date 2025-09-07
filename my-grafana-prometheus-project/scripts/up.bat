@echo off
setlocal
pushd "%~dp0.."

echo Resolving Windows host IP and updating Prometheus config ...
powershell -NoProfile -ExecutionPolicy Bypass -File ".\scripts\resolve-windows-host-ip.ps1"
if errorlevel 1 goto :end

echo Starting podman-compose in %CD% ...
podman-compose up -d
:end
set ERR=%ERRORLEVEL%
popd
echo.
pause
exit /b %ERR%
