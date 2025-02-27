:: Discover the current release directory from the directory
:: of this script and the start_erl.data file
@echo off
set script_dir=%~dp0
for %%A in ("%script_dir%\..") do (
  set release_root_dir=%%~fA
)
set rel_name=showoff
set rel_vsn=0.2.0
set boot_script=%release_root_dir%\releases\%rel_vsn%\%rel_name%.ps1

:: Use pwsh.exe rather than powershell.exe if available
set prog=powershell
where pwsh >nul 2>nul
if %ERRORLEVEL% equ 0 (
  set prog=pwsh
)
%prog% -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "& '%boot_script%' @args" %*
