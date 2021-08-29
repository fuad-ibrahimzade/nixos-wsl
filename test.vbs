' 'Dim oShell
' Set oShell = WScript.CreateObject ("WScript.Shell")
' oShell.run "cmd /min /C ""set __COMPAT_LAYER=RUNASINVOKER && start """" diskpart /s vdisk_minimizing_script.txt"" "
' Set oShell = Nothing'

' CreateObject("Wscript.Shell").Run "E:\WSLd\NixOS\minimize.bat",0,True

Set WshShell = CreateObject("WScript.Shell")

WshShell.Run """" & "E:\WSLd\NixOS\minimize.bat" & """" & sargs, 0, False
Set WshShell = Nothing