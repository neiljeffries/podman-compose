@echo off
setlocal
pushd "%~dp0.."

echo Building app image ...
podman-compose build app
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
