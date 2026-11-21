@echo off
@REM ----------------------------------------------------------------------------
@REM Maven Wrapper (Windows)
@REM Uso:  mvnw.cmd spring-boot:run   |   mvnw.cmd test   |   mvnw.cmd clean package
@REM A logica fica em .mvn\wrapper\mvnw.ps1
@REM ----------------------------------------------------------------------------
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0.mvn\wrapper\mvnw.ps1" %*
exit /b %ERRORLEVEL%
