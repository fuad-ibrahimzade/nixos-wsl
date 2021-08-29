#!/bin/bash -e
if [[ -z "${NixOSHOMEWindows}" ]]; then
    export NixOSHOMEWindows=$(pwd);
    # export WSLENV="$NixOSHOMEWindows/wp"
fi
cd /home/nixos;clear;
function cleanup {
    read -r -p "Choose to reduce wsl vdisk or not (default: n, [select y or n]):" reduce_vdisk
	reduce_vdisk=${reduce_vdisk:-n}
	if [[ $reduce_vdisk != "y" ]]; then
		exit;
	fi

	tee "$NixOSHOMEWindows/created.bat" <<- EOF
@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
    
cd /d "%NixOSHOME%"
wsl --shutdown

(
echo select vdisk FILE="%NixOSHOME%\NixOS\ext4.vhdx"
echo detach vdisk
echo exit
) > "%NixOSHOME%/pre_vdisk_minimizing_script.txt"
call cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" diskpart /s pre_vdisk_minimizing_script.txt"

(
echo select vdisk FILE="%NixOSHOME%\NixOS\ext4.vhdx"
echo attach vdisk readonly
echo compact vdisk
echo detach vdisk
echo exit
) > "%NixOSHOME%/vdisk_minimizing_script.txt"
@REM bypass admin uac
call cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" diskpart /s vdisk_minimizing_script.txt"
DEL "%NixOSHOME%/vdisk_minimizing_script.txt"
echo %DATE% %TIME% > "%NixOSHOME%/lastminimized.txt"
	EOF


    /mnt/c/Windows/System32/cmd.exe /min /C "cd /d %NixOSHOME% && created.bat"
    # /mnt/c/Windows/System32/cmd.exe /min /C "%NixOSHOME%/created.bat"
    # /mnt/c/Windows/System32/cmd.exe /C "cd /d E:\\WSLd\\NixOS && NixOsMinimizeDiskImage.bat"
}
trap cleanup EXIT