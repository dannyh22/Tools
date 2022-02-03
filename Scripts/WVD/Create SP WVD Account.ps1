Install-Module AzureAD
Import-Module AzureAD
$aadContext = Connect-AzureAD
$svcPrincipal = New-AzureADApplication -AvailableToOtherTenants $true -DisplayName "SET SP NAME HERE"
$svcPrincipalCreds = New-AzureADApplicationPasswordCredential -ObjectId $svcPrincipal.ObjectId

#SP Password#
$svcPrincipalCreds.Value

#SP APP ID#
$svcPrincipal.AppId

#Tenant ID#
$aadContext.TenantId.Guid

Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
Get-RdsTenant

#Assign SP Ownership to Tenant#
$myTenantName = "TENANT NAME HERE"
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -ApplicationId $svcPrincipal.AppId -TenantName $myTenantName