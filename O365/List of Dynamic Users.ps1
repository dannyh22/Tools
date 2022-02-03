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




#CHECK DYNAMIC LIST USERS, EXPORT TO CSV#
#
#
#
#
#
#
$AS = Get-DynamicDistributionGroup "All Staff"

Get-Recipient -ResultSize Unlimited -RecipientPreviewFilter $AS.RecipientFilter -OrganizationalUnit $AS.RecipientContainer | Select-Object Name,Primary* | Export-Csv c:\temp\Members\principals.csv

Get-DistributionGroupmember -Identity faq@uhsm.com | Export-Csv c:\temp\Members\members.csv

