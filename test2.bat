@echo off      

@REM %comspec% /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" createtodelete.bat"
@REM cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" batWithUACRequiringApp.bat"

@REM wsl --shutdown
@REM (
@REM echo select vdisk FILE="E:\WSLd\NixOs\NixOS\ext4.vhdx"
@REM echo compact vdisk
@REM echo exit
@REM ) > script.txt
@REM @REM bypass admin uac
@REM cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" diskpart /s script.txt"
@REM DEL script.txt
@REM echo %DATE% %TIME% > lastminimized.txt

(
    echo wsl --shutdown^
    (^
    echo select vdisk FILE="E:\WSLd\NixOs\NixOS\ext4.vhdx"^
    echo compact vdisk^
    echo exit^
    ) > script.txt^
    @REM bypass admin uac^
    cmd /min /C "set __COMPAT_LAYER=RUNASINVOKER && start "" diskpart /s script.txt"^
    DEL script.txt^
    echo %DATE% %TIME% > lastminimized.txt^
)>"%temp%\NixOsCleaner.vbs"
"%temp%\NixOsCleaner.vbs"


@REM echo asdas > "%temp%\getadmin.vbs" 
@REM "%temp%\getadmin.vbs" 
