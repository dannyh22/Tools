#Use this script to install Windows updates Surpress responses.
#Don't forget to set VARIABLES 1st! 

#Run "Set-ExecutionPolicy unrestricted" to enable PS scripts.
#Run "$PSVersionTable" to confirm PSVersion 3 or greater.


$TimeStamp = get-date -format g	
write-output "$TimeStamp          Windows Updates          Started" | Out-File C:\setup\setup.log -Append
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# |||||||||||||||||||||||||||||||||||||||||||||||||||
#                SET VARIABLES ABOVE!!!!


Write-Host "Ready to Install Updates" -ForegroundColor Magenta
Pause
Get-WUInstall -MicrosoftUpdate -AcceptAll -AutoReboot

Write-Host "Updates Completed" -ForegroundColor Magenta
$ModuleLocation = "\\snapitutil1\apps\Application Installs\PowerShell Modules\PSWindowsUpdate"
$TimeStamp = get-date -format g	
write-output "$TimeStamp          Windows Updates           Complete" | Out-File C:\setup\setup.log -Append

pause

