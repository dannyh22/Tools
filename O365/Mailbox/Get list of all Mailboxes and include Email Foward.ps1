#CONNECT TO O365####
#
#
#
#
#
Set-ExecutionPolicy RemoteSigned

$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection


Import-PSSession $Session -AllowClobber


###OPTIONS

Get-Mailbox "OR"

Get-Mailbox -RecipientTypeDetails SharedMailbox | 

Get-DistributionGroup

Get-GroupMailbox


#Get list of all Mailboxes and include Email Foward
#
#
#
#
#
Get-Mailbox -RecipientTypeDetails SharedMailbox  | select primarysmtpaddress,ForwardingSmtpAddress,DeliverToMailboxAndForward | Export-csv c:\temp\distributionforward.csv -NoTypeInformation