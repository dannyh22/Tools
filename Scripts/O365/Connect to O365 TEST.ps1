$securePword = Read-Host -AsSecureString

$encrypted = ConvertFrom-SecureString -SecureString $SecurePword -Key (1..16)

$encrypted | Set-Content Encrypted.txt

$user = "dalvarez@sureco.com"

$Pword = Get-Content Encrypted.txt | ConvertTo-SecureString -Key (1..16)

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

#Connect to O365
Connect-ExchangeOnline -Credential $Credential -ShowProgress $true


Remove-Mailbox -Identity jmorales@ihealthrive.com


Undo-SoftDeletedMailbox -SoftDeletedObject jmorales@ihealthrive.com



$securePword = Read-Host -AsSecureString

$encrypted = ConvertFrom-SecureString -SecureString $securePword -Key (1...16)

$encrypted | Set-Content .\Encrypted.txt

$user = "dalvarez@sureco.com"


$Pword = Get-Content Encrypted.txt | ConvertTo-SecureString -Key (1..16)

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord