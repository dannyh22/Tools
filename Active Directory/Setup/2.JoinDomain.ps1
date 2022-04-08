#Use this script to Join to the ERI domain
#Don't forget to set VARIABLES 1st! 

#Run "Set-ExecutionPolicy unrestricted" to enable PS scripts.
#Run "$PSVersionTable" to confirm PSVersion 3 or greater.# Hacked together by Sean Johnson on 9-22-16

$TimeStamp = get-date -format g	
write-output "$TimeStamp          2.JoinDomain.ps1          Started" | Out-File C:\setup\setup.log -Append

#Add computer to Domain
	$ComputerName = $env:computername
	add-computer -computername $ComputerName -domainname "ERIERI" -oupath "OU=Computers,OU=Managed Machines,DC=ERIERI,DC=local"
	Write-host "Press any key to restart system."
$TimeStamp = get-date -format g	
write-output "$TimeStamp          2.JoinDomain.ps1          Complete" | Out-File C:\setup\setup.log -Append	
	pause


	restart-computer
		