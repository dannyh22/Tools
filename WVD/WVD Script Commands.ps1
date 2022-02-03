Import-Module Microsoft.Rdinfra.RdPowershell
Install-Module Microsoft.Rdinfra.RdPowershell
Add-RdsAccount -DeploymentUrl https://rdbroker.wvd.microsoft.com
New-RdsTenant -Name Sureco-Test -AadTenantId f82bd569-15bf-4ed7-8826-f1bbf3b3fb53 -AzureSubscriptionId dc6ca423-103c-41d0-b286-1e9c8017c0ba
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -UserPrincipalName "dalvarez@sureco.com" -TenantGroupName "Default Tenant Group" -TenantName "Sureco-SysAdmins" 
New-RdsAppGroup -TenantName Sureco-RemoteSales -HostPoolName WVD-Host-Sales  -AppGroupName "Remote Application Group"
Add-RdsAppGroupUser -TenantName Sureco-RemoteSales -HostPoolName WVD-Host-Sales -AppGroupName "Remote Application Group" -UserPrincipalName fmuguerza@sureco.com