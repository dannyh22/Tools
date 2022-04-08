#Use this script to Onboard a Server
#Must Run as Administrator.  

#Run "Set-ExecutionPolicy unrestricted" to enable PS scripts.
#Run "$PSVersionTable" to confirm PSVersion 3 or greater.

$WUScripts = "\\snapitutil1\apps\Application Installs\New system\Server\Tech\WindowsUpdates"
$ModuleLocation = "\\snapitutil1\apps\Application Installs\PowerShell Modules\PSWindowsUpdate"
$TimeStamp = get-date -format g	
write-output "$TimeStamp          3.ServerConfig.ps1        Started" | Out-File C:\setup\setup.log -Append
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# |||||||||||||||||||||||||||||||||||||||||||||||||||
#                SET VARIABLES ABOVE!!!!
Write-Host "Only Continue if you varified all the VARIABLES" -ForegroundColor Magenta
Pause

#Maps to Application install server and copies Tech folder. 
write-host "Copying WindowsUpdates Scripts" -foregroundcolor yellow 
xcopy $WUScripts "C:\Tech\WindowsUpdates" /S/I/Y
c:
write-host "Copying Complete" -foregroundcolor yellow 


#Configuring Windows Update	
#Importing Update Module
Write-Host "Importing Windows Update Module" -ForegroundColor Magenta
xcopy $ModuleLocation "C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate" /S/I/Y
Import-Module PSWindowsUpdate
$TimeStamp = get-date -format g
echo "Windows Update Modules Installed  - $TimeStamp" >>"c:\tech\logs\WindowUpate.log"
Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false
Write-Host "Windows Update Module Import Complete" -ForegroundColor Magenta

#Scheduleing Updates
schtasks /delete /tn UpdateRestart /F
schtasks /delete /tn WindowsUpdate /F
schtasks /delete /tn WindowsUpdates /F
schtasks /delete /tn WUVerify /F
$SAT = Read-Host -Prompt "Which Saturday of the Month? (First, Second, Fourth or Manual)" 
$User = "erieri\wupdates"
$Password = Read-Host -Prompt "Enter the Password for erieri\wupdates" 
IF ($SAT -eq "Manual"){
#Schedules WUVerify log at Startup
	schtasks /create /ru $User /rp $Password /RL HIGHEST /sc Onstart /tn WUVerify /tr "C:\tech\WindowsUpdates\WUVerify.bat" 
	write-host "WUVerify log set to run at Startup." -foregroundcolor green
	Write-Host "No Windows Update Tasks will be created" -foregroundcolor red
	}
ElseIF ($SAT -eq "Third"){
	Write-Host "We are not scheduling Updates on the Third Saturday at this time" -foregroundcolor Magenta
	#Schedules WUVerify log at Startup
	schtasks /create /ru $User /rp $Password /RL HIGHEST /sc Onstart /tn WUVerify /tr "C:\tech\WindowsUpdates\WUVerify.bat" 
	write-host "WUVerify log set to run at Startup." -foregroundcolor green
	Write-Host "No Windows Update Tasks will be created" -foregroundcolor red
	}
Else {
$RSTime = Read-Host -Prompt "What Time should the pre-update restart begin? (Format Must be hh:mm:ss)" 
$Time = Read-Host -Prompt "What Time Should the updates install?(Format Must be hh:mm:ss)" 

#Scheduling Pre-install Restart
schtasks /create /ru $User /rp $Password /RL HIGHEST /sc Monthly /MO $SAT /D Sat /tn UpdateRestart /tr "C:\tech\WindowsUpdates\restart.bat" /st $RStime
write-host "Pre-install Restart Scheduled on the $SAT Saturday of the month at $RSTime" -foregroundcolor green

#Scheduling Windows Updates
schtasks /create /ru $User /rp $Password /RL HIGHEST /sc Monthly /MO $SAT /D Sat /tn WindowsUpdates /tr "C:\tech\WindowsUpdates\Windowsupdate.bat" /st $time
write-host "Windows Updates are now scheduled to run on the $SAT Saturday of the month at $Time" -foregroundcolor green

#Schedules WUVerify log at Startup
schtasks /create /ru $User /rp $Password /RL HIGHEST /sc Onstart /tn WUVerify /tr "C:\tech\WindowsUpdates\WUVerify.bat" 
write-host "WUVerify log set to run at Startup." -foregroundcolor green

}
write-host "Windows Update Scheduling complete." -foregroundcolor green

#Setting Update Service to Automatic
write-host "Configuring Windows Update Service" -foregroundcolor yellow
Stop-Service -Name "wuauserv" -Force
Set-service -Name "wuauserv" -StartupType "Automatic"
Start-Service -Name "wuauserv"

#Installing Updates
Write-Host "Ready to Install Updates" -ForegroundColor Magenta
Get-WUInstall -WindowsUpdate -IgnoreUserInput -AcceptAll -IgnoreReboot
Write-Host "Updates Completed" -ForegroundColor Magenta