#
# Source: DotJim blog (http://dandraka.com)
# Jim Andrakakis, August 2019
#
param([string]$PathToCheck = "E:\WSLd\NixOS\NixOS")
 
Clear-Host
$ErrorActionPreference = "Stop"
 
$url = "https://download.sysinternals.com/files/Handle.zip"
 
# === download handle.exe from microsoft ===
$tempDir = [System.IO.Path]::GetTempPath()
$handlePath = [System.IO.Path]::Combine($tempDir, "handle64.exe")
if (-not (Test-Path $handlePath)) {    
    $output = [System.IO.Path]::Combine($tempDir, "handle.zip")
    Invoke-WebRequest -Uri $url -OutFile $output
    Expand-Archive -LiteralPath $output -OutputPath $tempDir
}
 
# === run handle.exe ===
# see https://octopus.com/blog/how-to-handle-locked-files to see why the reg entry is needed
& reg.exe ADD "HKCU\Software\Sysinternals\Handle" /v EulaAccepted /t REG_DWORD /d 1 /f | Out-Null
$handleOutput = & $handlePath -a $PathToCheck
 
# === do we have to kill anything? ===
if ($handleOutput -match "no matching handles found") {
    Write-Host "Nothing to kill, exiting"
    exit
}
 
# === get process ids from handle.exe output ===
$pidList = New-Object System.Collections.ArrayList
$lines = $handleOutput | Split-String -RemoveEmptyStrings -separator "`n"
foreach($line in $lines) {
  # sample line: 
  # chrome.exe         pid: 11392  type: File           5BC: C:\Windows\Fonts\timesbd.ttf
  # regex to get pid and process name: (.*)\b(?:.*)(?:pid: )(\d*)
  $matches = $null
  $line -match "(.*)\b(?:.*)(?:pid: )(\d*)" | Out-Null
  if (-not $matches) { continue }
  if ($matches.Count -eq 0) { continue }
  $pidName = $matches[1]
  $pidStr = $matches[2]
  if ($pidList -notcontains $pidStr) { 
    Write-Host "Will kill process $pidStr $pidName"
    $pidList.Add($pidStr) | Out-Null
  }
}
 
# === DIE PROCESS DIE ===
foreach($pidStr in $pidList) {
    $pidInt = [int]::Parse($pidStr)    
    Stop-Process -Id $pidInt -Force
    Write-Host "Killed process $pidInt"
}
 
Write-Host "Finished"