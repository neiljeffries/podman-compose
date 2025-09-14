@echo off
setlocal
pushd "%~dp0.."

echo Restarting containers in compose project ...
podman compose restart prometheus grafana loki promtail app
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
