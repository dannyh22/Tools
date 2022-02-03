#Connect to O365#
#
#
#
#
Set-ExecutionPolicy RemoteSigned

$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection


Import-PSSession $Session -DisableNameChecking


#Bulk Add/Remove MailboxFolderPermission#
#
#
#
$GroupMembers = Get-DistributionGroupMember Managers

foreach ($GroupMember in $GroupMembers) { Add-MailboxFolderPermission -Identity (""+ $GroupMember.Guid+ ":\Calendar") -User soberacker@sureco.com -AccessRights Author}

Get-MailboxFolderPermission -Identity hneser@sureco.com:\calendar -User soberacker@sureco.com

