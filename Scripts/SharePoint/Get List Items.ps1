Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#Get SPO Content
Function Get-SPOContext([string]$Url,[string]$UserName,[SecureString]$Password)
{
$SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
$context = New-Object Microsoft.SharePoint.Client.ClientContext($Url)
$context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword)
return $context
}

#Read SPList and Return All Items
$ListTitle = "NewEmployee"
Function Get-ListItems([Microsoft.SharePoint.Client.ClientContext]$Context, [String]$ListTitle) {
$list = $Context.Web.Lists.GetByTitle($listTitle)
$Context.Load($list)
$cquery = New-Object Microsoft.SharePoint.Client.CamlQuery

$cquery.ViewXml = 'Request Submitted'
$items = $list.GetItems($cquery)
$Context.Load($items)
$Context.ExecuteQuery()
return $items
}


