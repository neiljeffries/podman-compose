@echo off
setlocal
pushd "%~dp0.."

echo Tailing logs for pod monitoring-pod (Ctrl+C to stop) ...
podman pod logs -f monitoring-pod
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
