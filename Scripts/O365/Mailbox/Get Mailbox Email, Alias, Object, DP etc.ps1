#Connect to O365
$user = "dalvarez@sureco.com"

$Pword = Get-Content Encrypted.txt | ConvertTo-SecureString -Key (1..16)

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

#Connect to O365
Connect-ExchangeOnline -Credential $Credential -ShowProgress $true


#Get Mailbox

Get-EXOMailbox -Filter {EmailAddresses -like '*docday*'} | Format-Table UserPrincipalName, Alias, PrimarySmtpAddress