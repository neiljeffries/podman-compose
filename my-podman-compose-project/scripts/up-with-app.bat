@echo off
setlocal
pushd "%~dp0.."

echo Writing Prometheus config for in-pod app ...
> .\prometheus.yml (
  for /f "delims=" %%i in ('type .\prometheus-internal.yml.tmpl') do @echo %%i
)

if errorlevel 1 goto :end

echo Starting stack with app profile ...
podman-compose --profile app up -d

:end
set ERR=%ERRORLEVEL%
popd
echo.
pause
exit /b %ERR%
