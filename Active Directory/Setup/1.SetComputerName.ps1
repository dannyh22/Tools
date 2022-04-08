#Use this script to Change Computer Name
#Don't forget to set VARIABLES 1st! 

#Run "Set-ExecutionPolicy unrestricted" to enable PS scripts.
#Run "$PSVersionTable" to confirm PSVersion 3 or greater.
$TimeStamp = get-date -format g	
write-output "$TimeStamp          1.SetComputerName.ps1     Started" | Out-File C:\setup\setup.log -Append


#Enable RDP
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

#Change Computer Name
	$ComputerName = $env:computername
	wmic csproduct get vendor,name,identifyingnumber
	write-host "Enter new computer name: " -foregroundcolor yellow -NoNewline	
	$NewComputerName = read-host 
	Rename-computer -newname $NewComputerName -ComputerName $ComputerName
	write-host "New computer name is now $NewComputerName."
	Write-host "Press any key to restart system."
	
$TimeStamp = get-date -format g	
write-output "$TimeStamp          1.SetComputerName.ps1     Completed" | Out-File C:\setup\setup.log -Append
pause
	restart-computer