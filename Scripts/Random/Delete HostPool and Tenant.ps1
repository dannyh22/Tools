#Delete: 
# 1.)Sesssion Hosts
# 2.)Desktop Application Group
# 3.)Host Pool
# 4.)Tenant

#Connect to WVD Powershell#
Add-RdsAccount -DeploymentUrl https://rdbroker.wvd.microsoft.com


$Tenant = "Sureco-SysAdmins"
$hostpool = "WVDTest"


#Check HOST POOLS#

Get-RdsHostPool -TenantName $Tenant


#Delete Session Hosts#

Get-RdsSessionHost -TenantName $Tenant -HostPoolName $hostpool
Remove-RdsSessionHost -TenantName $Tenant -HostPoolName $hostpool -Name VDI-6.sureco.com -Force



#Delete APP Group#

Remove-RdsAppGroup -TenantName $Tenant -HostPoolName $hostpool -Name "Desktop Application Group"



#Delete Host Pool#

Remove-RdsHostPool -TenantName $Tenant -Hostpool $hostpool



#Delete Tenant#

Remove-RdsTenant -Name $Tenant



#UNSUBSCRIBE FROM RDP THEN SIGN BACK IN!!!!!####