Get-ADUser -Filter 'HomeDrive -ne "$Null"' `
-Property Name,HomeDirectory,SamAccountName |
export-csv -path (Join-Path $pwd users.csv) -encoding ascii -NoTypeInformation
