@echo off
setlocal
pushd "%~dp0.."

echo Opening shell in app container ...
podman-compose exec app sh
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
