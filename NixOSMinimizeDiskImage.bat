@echo off

@REM :: BatchGotAdmin
@REM :-------------------------------------
@REM REM  --> Check for permissions
@REM >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

@REM REM --> If error flag set, we do not have admin.
@REM if '%errorlevel%' NEQ '0' (
@REM     echo Requesting administrative privileges...
@REM     goto UACPrompt
@REM ) else ( goto gotAdmin )

@REM :UACPrompt
@REM     echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
@REM     set params = %*:"=""
@REM     echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

@REM     "%temp%\getadmin.vbs"
@REM     del "%temp%\getadmin.vbs"
@REM     exit /B

@REM :gotAdmin
@REM     pushd "%CD%"
@REM     CD /D "%~dp0"

@REM %comspec% /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" createtodelete.bat"
@REM cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" batWithUACRequiringApp.bat"

@REM CreateObject("Wscript.Shell").Run "vpnshedule-migrasiya.bat",0,True

@REM wsl -e sudo fstrim /
@REM cmd /min /c cscript test.vbs

@REM wsl -d NixOS sudo fstrim /

@REM wsl --terminate NixOS @rem buggy prevents cleaning
wsl --shutdown
(
echo select vdisk FILE="%NixOSHOME%\NixOS\ext4.vhdx"
echo attach vdisk readonly
echo compact vdisk
echo detach vdisk
echo exit
) > vdisk_minimizing_script.txt
@REM bypass admin uac
cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" diskpart /s vdisk_minimizing_script.txt >> logfile.txt"
@REM call cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && call diskpart /s vdisk_minimizing_script.txt >> logfile.txt"
@REM DEL vdisk_minimizing_script.txt
echo %DATE% %TIME% > lastminimized.txt

@REM @REM @echo on
@REM diskpart /s vdisk_minimizing_script.txt
@REM @REM @echo off

@REM ".\test.vbs"


goto end-region-old-part2
@REM echo CreateObject("Wscript.Shell").Run "createtodelete.bat",0,True > "%temp%\getadmin.vbs" 

@REM @REM echo Set Shell = CreateObject("Shell.Application") > "%temp%\getadmin.vbs" 
@REM @REM echo Shell.ShellExecute "cmd", "/c cd /d E:\WSLd\NixOS && type nul > todelete.txt", , "runas", 0 >> "%temp%\getadmin.vbs" 
@REM "%temp%\getadmin.vbs" 

@REM wsl --shutdown
@REM @echo off
@REM (
@REM echo select vdisk FILE="E:\WSLd\NixOS\NixOS\ext4.vhdx"
@REM echo compact vdisk
@REM echo exit
@REM ) > script.txt
@REM diskpart /s script.txt
@REM DEL script.txt
:end-region-old-part2

goto end-region-old-part3
@REM setlocal EnableDelayedExpansion
@REM set multiLine=
@REM ^"tee -a /etc/pacman.conf ^<<- EOF^
@REM function cleanup {^
@REM     /mnt/c/Windows/System32/cmd.exe /C ^"cd /d E:\WSLd\NixOS && NixOsMinimizeDiskImage.bat^"^
@REM }^
@REM trap cleanup EXIT^
@REM EOF^
@REM ^"^
@REM line3
@REM wsl -d NixOS /bin/sh -c !multiLine!

@REM set script="echo 'function cleanup { /mnt/c/Windows/System32/cmd.exe /C \""cd /d E:\WSLd\NixOS && NixOsMinimizeDiskImage.bat\"" } trap cleanup EXIT' | sudo tee -a $HOME/.bashrc"
@REM (echo !script!) > xy.txt
@REM @REM echo !script!
@REM wsl -d NixOS /bin/sh -c <(type xy.txt)

@REM wsl -d NixOS /bin/sh -c <(echo.\"tee -a /etc/pacman.conf <<- EOF"
@REM echo."function cleanup {"
@REM echo."    /mnt/c/Windows/System32/cmd.exe /C \"cd /d E:\WSLd\NixOS && NixOsMinimizeDiskImage.bat\""
@REM echo."}"
@REM echo."trap cleanup EXIT"
@REM echo."EOF"
@REM echo.\"
@REM )

@REM wsl -d NixOS /bin/sh -c "echo '#/bin/bash -e' | tee -a $HOME/.bashrc"
@REM wsl -d NixOS /bin/sh -c "echo 'cd $HOME;clear;' | tee -a $HOME/.bashrc"

@REM setlocal EnableDelayedExpansion
@REM set multiLine=^
@REM "tee -a /etc/pacman.conf <<- EOF^
@REM function cleanup {^
@REM     /mnt/c/Windows/System32/cmd.exe /C "cd /d E:\WSLd\NixOS && NixOsMinimizeDiskImage.bat"^
@REM }^
@REM trap cleanup EXIT^
@REM EOF^
@REM "^
@REM line3
@REM wsl -d NixOS /bin/sh -c !multiLine!
:end-region-old-part3