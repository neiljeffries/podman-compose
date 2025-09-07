@echo off
setlocal
pushd "%~dp0.."

echo Stopping and removing stack (including volumes) ...
podman-compose down -v
if errorlevel 1 goto :end

echo Rebuilding images without cache ...
podman-compose build --no-cache app
if errorlevel 1 goto :end

echo Starting stack ...
podman-compose up -d
:end
set ERR=%ERRORLEVEL%
popd
echo.
pause
exit /b %ERR%
