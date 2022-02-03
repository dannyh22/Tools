Import-Module Microsoft.Rdinfra.RdPowershell
Install-Module Microsoft.Rdinfra.RdPowershell
Add-RdsAccount -DeploymentUrl https://rdbroker.wvd.microsoft.com


#Create Tenant#
New-RdsTenant -Name SureCo -AadTenantId f82bd569-15bf-4ed7-8826-f1bbf3b3fb53 -AzureSubscriptionId dc6ca423-103c-41d0-b286-1e9c8017c0ba



#Assign UPN RDS Owner Role"
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -UserPrincipalName dalvarez@sureco.com -TenantGroupName "Default Tenant Group" -TenantName SureCo1


#Create Host Pool#
New-RdsHostPool -TenantName Sureco -Name Technology -FriendlyName Technology


#Add User to Tenant and Host Pool#
Add-RdsAppGroupUser -TenantName Sureco -HostPoolName Technology -AppGroupName "Desktop Application Group" -UserPrincipalName dalvarez@sureco.com


#Change HostPool Name#
Set-RdsRemoteDesktop  -TenantName Sureco -HostPoolName Technology -AppGroupName "Desktop Application Group" -FriendlyName Technology






##########################################################
#REMOTE PUBLISHED APPS ONLY###



#Add to Remote App Group, used for published apps ONLY#
New-RdsAppGroup -TenantName Sureco-RemoteSales -HostPoolName WVD-Host-Proc -AppGroupName "Remote Application Group"
