$user = "dalvarez@sureco.com"

$Pword = Get-Content Encrypted.txt | ConvertTo-SecureString -Key (1..16)

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

#Connect to O365
Connect-ExchangeOnline -Credential $Credential -ShowProgress $true


#Forwarding Address and User
$forwardingaddress = "carrieremails@sureco.com"
$user = "enrollme@sureco.com"

#Creat Shared Mailbox 
Import-Csv C:\temp\tpa.csv | ForEach-Object {New-Mailbox -Shared -Name $_.name -DisplayName $_.displayname -PrimarySmtpAddress $_.smtp} -Confirm

#Set mailbox forward
Import-csv c:\temp\tpa.csv | ForEach-Object {Set-Mailbox -Identity $_.name -ForwardingAddress $forwardingaddress -HiddenFromAddressListsEnabled $true -IssueWarningQuota 2GB -ProhibitSendQuota 3GB -ProhibitSendReceiveQuota 3GB -UseDatabaseQuotaDefaults $false} -Confirm
 
###Add Recipient SendAs Permission
Import-csv c:\temp\tpa.csv |ForEach-Object {Add-RecipientPermission -Identity $_.name -Trustee $user -AccessRights SendAs} -Confirm


