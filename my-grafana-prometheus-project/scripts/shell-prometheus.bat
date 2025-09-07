@echo off
setlocal
pushd "%~dp0.."

echo Opening shell in prometheus container ...
podman-compose exec prometheus sh
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
