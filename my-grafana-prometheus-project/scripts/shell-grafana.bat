@echo off
setlocal
pushd "%~dp0.."

echo Opening shell in grafana container ...
podman-compose exec grafana sh
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
