#!/bin/bash


# $wslOutput = $(wsl -d NixOs) -join "`n"
# $wslOutput = $(wsl -d NixOs)
# $wslOutput = (wsl -d NixOs) | Out-String
# $wslOutput = & "wsl -d NixOs" 2>&1
# & "wsl -d NixOs" $params | Tee-Object -Variable wslOutput | Out-Null
# $wslOutput = (cmd /c "wsl -d NixOs" 2`>`&1)
# $wslOutput = & invoke-Expression "wsl -d NixOs" | Out-String
$wslOutput = (wsl -d NixOs 2>&1)


# $wslOutput

$String = 'There is no distribution with the supplied name.'

# echo "$wslOutput"
If ($wslOutput -like "*here*") {
  echo "true"
  write-host("This is if statement")
}
else {
  write-host("This is if statement2")

  echo "false"
}
echo $wslOutput
# If ('ABC'.IndexOf('b', [System.StringComparison]::InvariantCultureIgnoreCase) -ge 0) {
#   echo "true"
#   write-host("This is if statement")
# }
# else {
#   write-host("This is if statement2")

#   echo "false"
# }
# If ($wslOutput.contains($String)) {
#   echo "true"
#   write-host("This is if statement")
# }
# else {
#   write-host("This is if statement2")

#   echo "false"
# }

# function grep {
#   $input | out-string -stream | select-string $args
# }

# $SearchTerm = 'abc*'
# $String = 'abc def ghi jkl mno pqr stu vw xyz'

# $Result = $String | grep $SearchTerm

# echo $Result

$Result = ($String|out-string) -split "`n" | select-string 'abc' 

# $Result = $String | findstr -i $SearchTerm

# $Result = $String | Select-String -Pattern $SearchTerm

$FoundVariable = ($wslOutput|out-string) | select-string "There is no distribution with the supplied name"

# $Result = "wslOutput" | Select-String -Pattern "asdas"

# If ($wslOutput.contains($FoundVariable)) {
#   echo "true"
#   write-host("This is if statement")
# }
# else {
#   write-host("This is if statement2")

#   echo "false"
# }

echo $FoundVariable

# If ($String -like $SearchTerm) { Write-Output 'True' } Else { Write-Output 'False' }
