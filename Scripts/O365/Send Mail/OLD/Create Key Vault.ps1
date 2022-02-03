$credential = Get-Credential

Register-SecretVault -Name MailSecret-Vault -ModuleName Microsoft.PowerShell.SecretStore -Description "Send Mail API"

# Create a new secret named Secret1
Set-Secret -Name MailSecret-Vault -Secret $credential

Unlock-SecretStore

Get-SecretInfo

#Get Secret username/pw in secure string

Get-Secret -Name MailSecret-Vault

#Get Secret username/pw in secure string and plaintext pw
(Get-Secret -Name MailSecret-Vault).GetNetworkCredential() | Select-Object *

#Storing Master Vault Password in XML
Get-Credential | Export-CliXml ~/vaultpassword.xml

#Verify Encrypted Master Vault Password
Get-Content ~/vaultpassword.xml

#Import Master Vault Password
$vaultpassword = (Import-CliXml ~/vaultpassword.xml).Password
Unlock-SecretStore -Password $vaultpassword
(Get-Secret -Name MailSecret-Vault).GetNetworkCredential() | Select-Object Password

