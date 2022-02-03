#Reinstalling the Agent on WVD VM#

$tenant = "SureCo"
$problemhost = "Sales-4.sureco.com"
$hostpool = "Sales"


Set-ExecutionPolicy Unrestricted

Install-Module Microsoft.Rdinfra.RdPowershell

Import-Module Microsoft.Rdinfra.RdPowershell

Add-RdsAccount -DeploymentUrl https://rdbroker.wvd.microsoft.com


Remove-RdsSessionHost -TenantName $tenant -HostPoolName $hostpool -Name $problemhost


New-RdsRegistrationInfo -TenantName $tenant -HostPoolName $hostpool -ExpirationHours 72


$token = Export-RdsRegistrationInfo -TenantName $tenant -HostPoolName $hostpool 


cd C:\DeployAgent.\DeployAgent.ps1 -AgentInstallerFolder .\RDInfraAgentInstall -AgentBootServiceInstallerFolder .\RDAgentBootLoaderInstall -RegistrationToken $token