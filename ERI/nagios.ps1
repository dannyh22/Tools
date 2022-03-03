$computername = "SNA-DV2W5"
$credential = "daniel.alvarez.admin@erieri.com"

$serverPSSession = New-PSSession -ComputerName $computername -Credential $Credential -ErrorAction 'Stop'
Invoke-Command -Session $serverPSSession -ScriptBlock {New-Item -Path 'C:\temp' -Name 'NSClientFiles' -ItemType Directory -Force | Out-Null}
Copy-Item -Path '\\snapitutil1\Apps\Application Installs\Nagios Client\*' -Destination 'C:\temp\NSClientFiles' -Recurse -Force -ToSession $serverPSSession
Invoke-Command -Session $serverPSSession -ScriptBlock {Start-Process -FilePath 'C:\temp\NSClientFiles\NSCP-0.5.2.35-x64.msi' -ArgumentList '/quiet', '/norestart' -Wait}
Invoke-Command -Session $serverPSSession -ScriptBlock {Copy-Item -Path 'C:\temp\NSClientFiles\nsclient.ini' -Destination 'C:\Program Files\NSClient++\nsclient.ini' -Force}