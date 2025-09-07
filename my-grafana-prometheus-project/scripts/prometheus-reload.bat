@echo off
setlocal
pushd "%~dp0.."

echo Sending HUP to Prometheus for config reload ...
podman-compose exec prometheus kill -HUP 1
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
