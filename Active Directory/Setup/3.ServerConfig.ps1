#Use this script to Onboard a Server
#Must Run as Administrator.  

#Run "Set-ExecutionPolicy unrestricted" to enable PS scripts.
#Run "$PSVersionTable" to confirm PSVersion 3 or greater.

$ModuleLocation = "\\snapitutil1\apps\Application Installs\PowerShell Modules\PSWindowsUpdate"
$TimeStamp = get-date -format g	
write-output "$TimeStamp          3.ServerConfig.ps1        Started" | Out-File C:\setup\setup.log -Append
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# |||||||||||||||||||||||||||||||||||||||||||||||||||
#                SET VARIABLES ABOVE!!!!
Write-Host "Only Continue if you varified all the VARIABLES" -ForegroundColor Magenta
Pause
#Maps to Application install server and copies Tech folder. 
write-host "Copying Tech Folder" -foregroundcolor yellow 
net use Y: \\snapitutil1\Apps
robocopy "Y:\Application Installs\New system\Server\Tech" C:\Tech /e /z /r:10 /w:5 /mt /log+:c:\robocopy_Tech.log
c:
write-host "Copying Complete" -foregroundcolor yellow 

#Opens firewall for File and Print Sharing
write-host "Setting up File and Print Sharing" -foregroundcolor yellow 
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
write-host "File and Print Sharing Setup Complete" -foregroundcolor yellow 

#Sets Time Zone to Pacific
# ---	write-host "Setting TimeZone" -foregroundcolor yellow 
# ---	Set-TimeZone -Name "Pacific Standard Time"
# ---	write-host "TimeZone Set" -foregroundcolor yellow 

#Turns on Remote Registry
$regkeypath = "HKLM:\System\CurrentControlSet\Services"
Set-ItemProperty -Path $regkeypath\RemoteRegistry -Name "DisplayName" -Value "Remote Registry"
Set-ItemProperty -Path $regkeypath\RemoteRegistry -Name "Start" -Value 2

#Disables SMBv1
write-host "Disabling SMBv1" -foregroundcolor yellow 
cd c:\Tech\Software\SMBv1
sc.exe config lanmanworkstation depend= bowser/mrxsmb20/nsi
sc.exe config mrxsmb10 start= disabled
REGEDIT /S SMB1.reg
write-host "SMBv1 Disabled" -foregroundcolor yellow 

#Enables Telnet
write-host "Enabling Telnet" -foregroundcolor yellow 
install-windowsfeature "telnet-client" 
write-host "Telnet Enabled" -foregroundcolor yellow 

#Enables Desktop Experience
write-host "Enabling Desktop Experience" -foregroundcolor yellow 
Install-WindowsFeature "Desktop-Experience"
write-host "Desktop Experience Enabled" -foregroundcolor yellow 

#Installing Applications
#Installing Chrome
write-host "Checking for Google Chrome" -foregroundcolor yellow
IF (test-path "C:\Program Files (x86)\Google\Chrome\Application")
	{
	write-host "Google Chrome Exists" -foregroundcolor green}
Else {
	write-host "Installing Google Chrome: " -foregroundcolor yellow 
	cd "c:\Tech\Software\Chrome"
	.\ChromeSetup.exe /silent /install 
	write-host "Google Chrome install complete: " -foregroundcolor green
	}

#Installing Firefox
write-host "Checking for Firefox" -foregroundcolor yellow
IF (test-path "C:\Program Files\Mozilla Firefox"){
	write-host "Firefox Exists" -foregroundcolor green
	}
Else {
	write-host "Installing Firefox: " -foregroundcolor yellow 
	cd "c:\Tech\Software\Firefox"
	.\FirefoxSetup49.0.2.exe /S
	write-host "Firefox install complete: " -foregroundcolor green 
}

#Installing Notepad++
write-host "Checking for Notepad++" -foregroundcolor yellow
IF (test-path "C:\Program Files (x86)\Notepad++"){
	write-host "Notepad++ Exists" -foregroundcolor green
	}
Else{
	write-host "Installing Notepad++: " -foregroundcolor yellow 
	cd "c:\Tech\Software\Notepad++"
	.\npp.7.2.Installer.exe /S
	Start-Sleep -Seconds 90
	cd "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Notepad++"
	Copy-Item .\Notepad++.lnk -Destination C:\Users\Public\Desktop
	write-host "Notepad++ install complete: " -foregroundcolor green
}
	
#Installing Nagios Client
write-host "Checking for Nagios Client" -foregroundcolor yellow
IF (test-path "C:\Program Files\NSClient++"){
	write-host "Nagios Exists" -foregroundcolor green
	}
Else {
	write-host "Installing Nagios Client: " -foregroundcolor yellow
	cd "c:\tech\software\Nagios Client"
	.\NSCP-0.5.0.62-x64.msi /quiet /norestart /log "c:\tech\logs\Nagios Client info.%date:~4,2%_%date:~7,2%_%date:~12,2%.log"
	ping 10.4.0.1 -n 120
	copy nsclient.ini "c:\Program Files\NSClient++\nsclient.ini" /Y
	net stop nscp
	net start nscp
	write-host "Nagios Client Installed: " -foregroundcolor green
	}

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

#Installing Symantec Endpoint Protection
write-host "Checking for Symantec Endpoint Protection" -foregroundcolor yellow
IF (test-path "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection"){
	write-host "Symantec Exists" -foregroundcolor green}
Else {
	write-host "Installing Symantec Endpoint Protection: " -foregroundcolor yellow 
	cd "c:\Tech\Software\Symantec Client"
	.\setup.exe
	write-host "Press any key once Symantec Endpoint Protection Install complete: " -foregroundcolor green 
	
}

$TimeStamp = get-date -format g	
write-output "$TimeStamp          3.ServerConfig.ps1  Complete" | Out-File C:\setup\setup.log -Append

write-host "ServerConfig Complete: " -foregroundcolor yellow 













