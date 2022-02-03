Import-Module Microsoft.Rdinfra.RdPowershell
Install-Module Microsoft.Rdinfra.RdPowershell
Add-RdsAccount -DeploymentUrl https://rdbroker.wvd.microsoft.com


Set-RdsHostPool -TenantName Sureco -Name Accounting -CustomRdpProperty "audiomode:i:0;audiocapturemode:i:1;camerastoredirect:s:*;devicestoredirect:s:*;redirectclipboard:i:0"