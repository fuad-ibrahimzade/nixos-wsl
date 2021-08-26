@echo off
@setlocal EnableDelayedExpansion 


@REM Powershell.exe -executionpolicy remotesigned -File  test.ps1

REM wsl -d NixOs /nix/var/nix/profiles/system/activate
REM FOR /F "delims=" %i IN ('wsl -d NixOs) DO set wslResp=%i
REM echo %wslResp%
REM for /F "delims=delim" %%i in ('wsl -d NixOs') do set wslResp=%%i
REM echo wslResp is %wslResp%

>>"result.txt" (
	wsl -d NixOs
)
REM wsl -d NixOs > result.txt
set content=
for /f "delims=" %%i in ('result.txt') do set content=%content% %%i
@REM del result.txt

@REM echo %%a|find "substring" >nul
@REM if errorlevel 1 (echo notfound) else (echo found)

@REM set SOURCE=("result.txt")
@REM FOR /F "usebackq delims=" %%A IN ("%SOURCE%") DO (
@REM     ECHO %%A
@REM )

@REM set line=
@REM for /f "tokens=*" %%a in (result.txt) do (
@REM   echo line=%%a
@REM )

set var=
set /p var= <result.txt
echo !var!



echo !content!
echo !SOURCE!

REM set wslresp="asdasd"
REM If "%wslresp%"=="there is no distribution with the supplied name." (
	REM echo directory
REM ) else (
	REM echo other
REM )

REM cmder /single /x "/cmd %cd%
REM \"c:\folder one\test.bat\""

echo on