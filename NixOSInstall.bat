@echo off       
goto end-region-old 
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
@REM powershell -command "start-bitstransfer -source https://github.com/fuad-ibrahimzade/nixos-wsl/releases/download/nixos-tarball/nixos-system-x86_64-linux.tar.gz -destination nixos-system-x86_64-linux.tar.gz"
:end-region-old

@REM SET downloadUrl=https://api.github.com/users/marktiedemann
@REM SET tempFile=%cd%\.%random%-tmp

@REM BITSADMIN /transfer /download %downloadUrl% %tempFile% >nul
@REM TYPE %tempFile%
@REM DEL %tempFile%


wsl --unregister NixOS
wsl --shutdown
DEL lastinstalled.txt
DEL lastminimized.txt

set NixOSHOME="%cd%"
setx NixOSHOME "%cd%"

(
echo select vdisk FILE="%NixOSHOME%\NixOS\ext4.vhdx"
echo detach vdisk
echo exit
) > "%NixOSHOME%/pre_vdisk_minimizing_script.txt"
call cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" diskpart /s pre_vdisk_minimizing_script.txt"
DEL pre_vdisk_minimizing_script.txt



if EXIST lastinstalled.txt (
    wsl -d NixOS
) else (
    if EXIST  nixos-system-x86_64-linux.tar.gz (
        echo %DATE% %TIME% > lastinstalled.txt
    ) else (
        curl -L -O -J -R https://github.com/fuad-ibrahimzade/nixos-wsl/releases/latest/download/nixos-system-x86_64-linux.tar.gz
    )

    

    @REM IF %ERRORLEVEL% NEQ 0
    wsl -d NixOS || (
        wsl --import NixOS .\NixOS\ nixos-system-x86_64-linux.tar.gz --version 2
        wsl -d NixOS /bin/sh -c "ls $HOME/ || /nix/var/nix/profiles/system/activate"
        wsl -d NixOS /bin/sh -c "cat .bashrc | sudo tee -a $HOME/.bashrc"
        wsl -d NixOS
    )
)

