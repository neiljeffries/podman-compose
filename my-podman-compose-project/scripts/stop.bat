@echo off
setlocal
pushd "%~dp0.."

echo Stopping stack (no removal) ...
podman-compose stop
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
