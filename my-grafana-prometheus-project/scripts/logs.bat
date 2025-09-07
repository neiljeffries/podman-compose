@echo off
setlocal
pushd "%~dp0.."

echo Tailing logs for all services (Ctrl+C to stop) ...
podman-compose logs -f
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
