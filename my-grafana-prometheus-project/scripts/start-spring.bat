@echo off
setlocal enableextensions

REM Compute path to the Spring Boot project (three levels up from this script)
set "SCRIPT_DIR=%~dp0"
set "APP_DIR=%SCRIPT_DIR%..\..\..\spring-boot-micrometer-docker"

if not exist "%APP_DIR%\scripts\mvn-run.bat" (
  echo [start-spring] ERROR: mvn-run.bat not found at "%APP_DIR%\scripts\mvn-run.bat"
  echo [start-spring] Current script dir: %SCRIPT_DIR%
  echo [start-spring] Resolved app dir:    %APP_DIR%
  pause
  exit /b 1
)

pushd "%APP_DIR%" >NUL 2>&1
start "Spring: app (local)" cmd /k "title Spring: app (local) && call .\scripts\mvn-run.bat"
popd >NUL 2>&1

exit /b
