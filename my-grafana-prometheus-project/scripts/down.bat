@echo off
setlocal
pushd "%~dp0.."

echo Bringing down stack (keeping volumes) ...
podman-compose down
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
