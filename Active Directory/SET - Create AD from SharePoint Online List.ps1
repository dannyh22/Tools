<#
.SYNOPSIS
    The scripts creates and active directory users based on input from a SharePoint list in SharePoint Online.
    For more details, read at 365lab.net
.EXAMPLE
   .\CreateADUsersFromSPO.ps1 -Verbose
.NOTES
    File Name: CreateADUsersFromSPO.ps1
    Author   : Johan Dahlbom, johan[at]dahlbom.eu
    Blog     : 365lab.net 
    The script are provided “AS IS” with no guarantees, no warranties, and they confer no rights.
    Requires PowerShell Version 3.0!
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    $UPNSuffix = "sureco.com",
    $OrganizationalUnit = "OU,OU=Sync,OU=Users,OU=CA,DC=sureco,DC=com",
    [SecureString] $PasswordLength
)


#Import the Required Assemblys from the Client components SDK (https://www.microsoft.com/en-us/download/details.aspx?id=35585)
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName(“System.Web”) | Out-Null
  
#Import Active Directory Module
Import-Module ActiveDirectory -Verbose:$false
  
#Define SharePoint Online Credentials with proper permissions
$user = "dalvarez@sureco.com"
$Pword = Get-Content Encrypted.txt | ConvertTo-SecureString -Key (1..16)
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord


#Connect to O365
Connect-ExchangeOnline -Credential $Credential -ShowProgress $true


#SharePoint online address and list name
$SPOUrl = "https://sureco.sharepoint.com/"
$SPOList = "New Employee"
#Column Name mapping in SharePoint 
$SPListItemColumns = @{
        FirstName = "FirstName"
        LastName = "LastName"
        JobTitle = "JobTitle"
        Manager = "Manager"
        Department = "Department"
        Status = "Status"
        Mail = "EmailAddress"
        Company = "SureCo Inc."
}
 
#region functions
function Convert-ToLatinCharacters {
    param(
        [string]$inputString
    )
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($inputString))
}
  
function Get-JDDNFromUPN {
    param (
        [ValidateScript({Get-ADUser -Filter {UserprincipalName -eq $_}})] 
        [Parameter(Mandatory=$true)][string]$UserPrincipalName
    )
        $ADUser = Get-ADUser -Filter {UserprincipalName -eq $UserPrincipalName} -ErrorAction stop
        return $ADUser.distinguishedname
}
  
function New-JDSamAccountName {
    param (
        [Parameter(Mandatory=$true)][string]$FirstName,
        [Parameter(Mandatory=$true)][string]$LastName,
        [parameter(Mandatory=$false)][int]$FirstNameCharCount = 3,
        [parameter(Mandatory=$false)][int]$LastNameCharCount = 3
    )
    #Construct the base sAMAccountName
    $BaseSam = "{0}{1}" -f (Convert-ToLatinCharacters $FirstName).Substring(0,$FirstNameCharCount),(Convert-ToLatinCharacters $LastName).Substring(0,$LastNameCharCount)
  
    #Add a number until you find a free sAMAccountName
    if (Get-ADUser -Filter {samaccountname -eq $BaseSam} -ErrorAction SilentlyContinue) {
        $index = 0
        do {
            $index++
            $sAMAccountName = "{0}{1}" -f $BaseSam.ToLower(),$index
        } until (-not(Get-ADUser -Filter {samaccountname -eq $sAMAccountName } -ErrorAction SilentlyContinue))
    } else {
        $sAMAccountName = $BaseSam.tolower()
    }
    return $sAMAccountName
}
      
function New-JDUPNAndMail {
    param (
        [Parameter(Mandatory=$true)][string]$FirstName,
        [Parameter(Mandatory=$true)][string]$LastName,
        [Parameter(Mandatory=$true)][string]$UPNSuffix
     )
    #Construct the base userPrincipalName
    $BaseUPN = "{0}.{1}@{2}" -f (Convert-ToLatinCharacters $FirstName).replace(' ','.').tolower(),(Convert-ToLatinCharacters $LastName).replace(' ','.').tolower(),$UPNSuffix
      
    if (Get-ADUser -Filter {userprincipalname -eq $BaseUPN} -ErrorAction SilentlyContinue) {
        $index = 0
        do {
            $index++
            $UserPrincipalName = "{0}{1}@{2}" -f $BaseUPN.Split("@")[0],$index,$UPNSuffix
        } until (-not(Get-ADUser -Filter {userprincipalname -eq $UserPrincipalName} -ErrorAction SilentlyContinue))
  
    } else {
        $UserPrincipalName = $BaseUPN
    }
    return $UserPrincipalName
}
  
function New-JDADUser {
    [CmdletBinding(ShouldProcess=$true)]
    param (
        [Parameter(Mandatory=$true)][string]$FirstName,
        [Parameter(Mandatory=$true)][string]$LastName,
        [Parameter(Mandatory=$true)][string]$UserPrincipalName,
        [Parameter(Mandatory=$true)][string]$sAMAccountName,
        [Parameter(Mandatory=$true)][string]$Title,
        [Parameter(Mandatory=$true)][string]$OU,
        [Parameter(Mandatory=$true)][string]$Manager,
        [Parameter(Mandatory=$true)][int]$PasswordLength
    )
     #Generate a password
     $Password = [System.Web.Security.Membership]::GeneratePassword($PasswordLength,2)
  
     #Construct the user HT
     $ADUserHt = @{
        GivenName = $FirstName
        SurName = $LastName
        ChangePasswordAtLogon = $true
        EmailAddress = $UserPrincipalName
        UserPrincipalName = $UserPrincipalName
        sAMAccountName = $sAMAccountName
        Title = $Title
        Name = "$FirstName $LastName ($sAMAccountName)"
        Displayname = "$FirstName $LastName"
        Manager = $Manager
        Path = $OU
        AccountPassword = (ConvertTo-SecureString -String $Password -AsPlainText -Force)
        Enabled = $true
        OtherAttribute = @{proxyAddresses = "SMTP:$UserPrincipalName"}
     }
     try {
        #Create the user and return a custom object
        New-ADUser @ADUserHt -ErrorAction Stop 
        Write-Verbose "Successfully created the user $($ADUserHt.Name)"
        [pscustomobject] @{
            sAMAccountName = $ADUserHt.sAMAccountName 
            UserPrincipalName = $ADUserHt.UserPrincipalName 
            Password = $Password
        }
     } catch {
        Write-Warning "Error creating the user $($ADUserHt.Name) `r`n$_"
     }
}
  
function Send-JDWelcomeEmail {
    param (
        [Parameter(Mandatory=$true)][string]$Recipient,
        [Parameter(Mandatory=$false)][string]$Sender = "dalvarez@sureco.com",
        [Parameter(Mandatory=$true)][string]$uUserPrincipalName,
        [Parameter(Mandatory=$true)][string]$usAMAccountName,
        [Parameter(Mandatory=$true)][SecureString] $uPassword
    )
    $message = @"
    Hi,

    A user with the following account details was created in Active Directory:
    Username: $usAMAccountName
    EmailAddress: $uUserPrincipalName
    Password: $uPassword (needs to be changed at first logon)
  
    Best Regards
    365lab IT department
"@
    $MailMessageHt = @{
        From = $Sender
        To = $Recipient
        Body = $message
        SmtpServer = "smpt.offce365.com"
        Subject = "User $uUserPrincipalName was created"
    }
    Send-MailMessage @MailMessageHt
}
#endregion functions
  
#Connect to SharePoint Online
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SPOUrl)
$Context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User, $Pass)
#Get the list
$List = $Context.Web.Lists.GetByTitle($SPOList)
$Query = [Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery(100) 
$Items = $List.GetItems($Query)
$Context.Load($Items)
$Context.ExecuteQuery()
  
#Loop through list items
foreach($item in $Items) {
    #Get list item for later reference
    $ListItem = [Microsoft.SharePoint.Client.ListItem]$listItem = $List.GetItemById($Item.FieldValues["ID"])
    if ($item.FieldValues[$SPListItemColumns.Status] -eq "New") {
        Write-Verbose "Processing list item $Firstname $LastName with ID=$($item.FieldValues["ID"])"
  
        #Put the fieldvalues in variables.
        $FirstName = $item.FieldValues[$SPListItemColumns.FirstName]
        $LastName = $item.FieldValues[$SPListItemColumns.LastName]
        $Title = $item.FieldValues[$SPListItemColumns.Title]
        $Manager = $item.FieldValues[$SPListItemColumns.Manager].LookupValue


        #Generate Sam, UserPrincipalName/Email and the managers DN
        try {
            $sAMAccountName = New-JDSamAccountName -FirstName $Firstname -LastName $LastName
            $UPNandMail = New-JDUPNAndMail -FirstName $Firstname -LastName $LastName -UPNSuffix $UPNSuffix
            $ManagerDN = Get-JDDNFromUPN -UserPrincipalName $Manager
  
            #Create the user in Active Directory
            $NewAdUserHt = @{
                FirstName = $Firstname
                LastName = $LastName
                Manager = $ManagerDN
                sAMAccountName = $sAMAccountName
                UserPrincipalName = $UPNandMail
                Title = $Title
                OU = $OrganizationalUnit
                PasswordLength = [securestring]$PasswordLength
            }
            $ADUser = New-JDADUser @NewAdUserHt -ErrorAction Stop
            Write-Verbose "Created the AD user $sAMAccountName with UPN $UPNandMail"
  
            #Update EmailAddress in the SharePoint List
            $ListItem[$SPListItemColumns.Mail] = $ADUser.UserPrincipalName
            $ListItem[$SPListItemColumns.Status] = "Completed"
            Write-Verbose "Updated the SharePoint list item with status=Completed"
  
            #Send information to manager
            Send-JDWelcomeEmail -Recipient $Manager -uUserPrincipalName $UPNandMail -usAMAccountName $sAMAccountName -uPassword $ADUser.Password
            Write-Verbose "Sent account information to $Manager"
        } catch {
            Write-Warning $_
        }
        #Execute the changes
        $ListItem.Update()
        $Context.ExecuteQuery()
    }
}