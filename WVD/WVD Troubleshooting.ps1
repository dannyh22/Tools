#CHECKING RDSSESSION HOSTS#

Get-RdsSessionHost -TenantName "NAME" -HostPoolName "HP NAME"



#REMOVE VMS FROM TENANT/HOST POOL#
Remove-RdsSessionHost -TenantName Sureco -HostPoolName Accounting -name WVDTEST-0.sureco.com -force