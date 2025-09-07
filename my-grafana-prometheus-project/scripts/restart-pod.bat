@echo off
setlocal
pushd "%~dp0.."

echo Restarting Podman pod: monitoring-pod ...
podman pod restart monitoring-pod
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
