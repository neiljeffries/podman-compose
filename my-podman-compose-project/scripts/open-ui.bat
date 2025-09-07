@echo off
setlocal
pushd "%~dp0.."

start http://localhost:3000/
start http://localhost:9090/
start http://localhost:8080/actuator/health
set ERR=%ERRORLEVEL%

popd
echo.
pause
exit /b %ERR%
