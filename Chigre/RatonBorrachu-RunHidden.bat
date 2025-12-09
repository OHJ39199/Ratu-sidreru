@echo off
setlocal

chcp 65001 >nul 2>&1

rem --- Ruta del script PowerShell ---
set "PS1=%~dp0RatonBorrachu-Multi.ps1"

rem --- Comprobar existencia ---
if not exist "%PS1%" exit /b 1

rem --- Detectar PowerShell 7 si existe ---
set "PS=powershell.exe"
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "PS=%ProgramFiles%\PowerShell\7\pwsh.exe"
if exist "%ProgramFiles%\PowerShell\7-preview\pwsh.exe" set "PS=%ProgramFiles%\PowerShell\7-preview\pwsh.exe"

rem --- Ejecutar PowerShell normalmente (visible) ---
"%PS%" -ExecutionPolicy Bypass -NoProfile -File "%PS1%"

exit /b 0

