
#installs module
install-module -Name Az

#imports module
import-module Azaccount

#connects to AZ 
Login-AzAccount


$userPrincipalId = $(Get-AzureRmADUser -UserPrincipalName "dalvarez@sureco.com").Id
Set-AzureRmKeyVaultAccessPolicy -VaultName "CA-Server28464kv" -ObjectId $userPrincipalId -PermissionsToStorage get, list, delete, set, update, regeneratekey, getsas, listsas, deletesas, setsas, recover, backup, restore, purge


$userPrincipalId = $(Get-AzureRmADUser -UserPrincipalName "dalvarez@sureco.com").Id
Set-AzureRmKeyVaultAccessPolicy -VaultName "CA-Server28464kv" -ObjectId $userPrincipalId -PermissionsToStorage get, list, delete, set, update, regeneratekey, getsas, listsas, deletesas, setsas, recover, backup, restore, purge