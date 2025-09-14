@echo off
setlocal enableextensions

REM Kill local Spring Boot app on default port 8080 (adjust as needed)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0kill-local-java.ps1" -Port 8080

REM Bring down the podman compose stack
call "%~dp0down.bat"

REM Close this cmd window if it was launched directly (not from another script)
exit
