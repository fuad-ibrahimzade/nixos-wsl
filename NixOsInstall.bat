@REM @echo off        
@REM :: BatchGotAdmin        
@REM :-------------------------------------        
@REM REM  --> Check for permissions  
@REM >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"  
@REM REM --> If error flag set, we do not have admin.  
@REM if '%errorlevel%' NEQ '0' (    echo Requesting administrative privileges...    goto UACPrompt) else ( goto gotAdmin )  
@REM :UACPrompt  
@REM     echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"  
@REM     echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"  
@REM     "%temp%\getadmin.vbs"  
@REM     exit /B
@REM :gotAdmin  
wsl --import NixOS .\NixOS\ nixos-system-x86_64-linux.tar.gz --version 2
wsl -d NixOs /nix/var/nix/profiles/system/activate
@REM wsl -d NixOs