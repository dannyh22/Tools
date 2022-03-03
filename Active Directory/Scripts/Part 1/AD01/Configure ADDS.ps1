<#
# Configure ADDS, 2018/3/28 Niall Brady, https://www.windows-noob.com
#
# This script:            Configure AD DS Deployment (https://docs.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest?view=win10-ps)
# Before running:         Configure the variables below (lines 17-24)
# Usage:                  Run this script as Administrator on a WorkGroup joined server that is destined to become the ADDC
#>

  If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] “Administrator”))

    {
        Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”
        Break
    }

$DomainName = "windowsnoob.lab.local"
$DomainNetbiosName = "WINDOWSNOOB"
$SafeModeAdministratorPassword = convertto-securestring "P@ssw0rd" -asplaintext -force
$DomainMode = "WinThreshold"
$ForestMode = "WinThreshold"
$DatabasePath = "C:\Windows\NTDS"
$LogPath = "C:\Windows\NTDS"
$SysVolPath = "C:\Windows\SYSVOL"

Install-windowsfeature -name AD-Domain-Services –IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath $DatabasePath `
-DomainMode $DomainMode `
-DomainName $DomainName `
-DomainNetbiosName $DomainNetbiosName `
-ForestMode $ForestMode `
-InstallDns:$true `
-LogPath $LogPath `
-NoRebootOnCompletion:$false `
-SysvolPath $SysVolPath `
-SafeModeAdministratorPassword $SafeModeAdministratorPassword `
-Force:$true
