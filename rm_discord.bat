@echo off

setlocal

echo -----------------
echo This script removes Discord entries in the Windows registry, log files, shortcuts and other leftovers from trying to uninstall using the regular uninstall dialog. It is not meant to be used as an uninstaller, but can be used as so.
echo Please close Discord before proceeding. A backup of the registry file will be made.
echo -----------------

:choice
SET /P choice="Are you sure you wish to proceed? [y/n] (yes/no)"
if "%choice%"=="y" GOTO :continue 
if "%choice%"=="n" GOTO :eof

echo Invalid response (Type 'y' for yes and 'n' for no)
GOTO :choice

:continue

net session >nul 2>&1
if not %errorLevel%== 0 (echo Run CMD/Script as Admin and try again ^(Left click ^> Run as administrator^) && pause && GOTO :eof)

if "%1"=="s" (echo Skipping registry backup... && GOTO :skipreg)
echo Creating registry backup...

reg export HKLM hklm.reg > nul
reg export HKCU hkcu.reg > nul
reg export HKCR hkcr.reg > nul
reg export HKU  hku.reg > nul
reg export HKCC hkcc.reg > nul

:skipreg
echo Removing app data...

rmdir /S /Q "%appdata%/discord"
rmdir /S /Q "%localappdata%/Discord"
rmdir /S /Q "%localappdata%/SquirrelTemp"

echo Removing registry entries...

REG DELETE HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run /v Discord /f
REG DELETE HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run /v Discord /f

echo Finished removing Discord leftovers! Have a nice day.
endlocal


