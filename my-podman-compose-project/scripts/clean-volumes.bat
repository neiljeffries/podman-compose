@echo off
setlocal
pushd "%~dp0.."

echo Removing Grafana and Prometheus named volumes ...
podman volume rm -f my-podman-compose-project_prometheus-data 2>nul
podman volume rm -f my-podman-compose-project_grafana-data 2>nul
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
