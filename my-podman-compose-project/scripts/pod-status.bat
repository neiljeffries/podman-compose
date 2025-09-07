@echo off
setlocal
pushd "%~dp0.."

echo Pod status and containers ...
podman pod ps --filter name=monitoring-pod
podman ps --pod
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
