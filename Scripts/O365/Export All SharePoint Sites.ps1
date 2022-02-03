


Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
#
#
#
#
#
#
#
#Replace your admin site url
$AdminUrl = "https://sureco-admin.sharepoint.com/"
#
#
#
#Retrieve all site collections
Connect-SPOService -Url $AdminUrl
Get-SPOSite | Select Title, Url, Owner | Export-CSV "C:\temp\SharePoint-Online-Sites.csv" -NoTypeInformation -Encoding UTF8