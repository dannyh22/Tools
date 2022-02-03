#DONT FORGET TO CONNET TO AZURE AD FIRST :)#

#install AzureADPreview#
Remove-Module AzureAD -ErrorAction SilentlyContinue
Install-Module AzureADPreview
Import-Module AzureADPreview

"Connect to Exchange Online"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

#The moniker for dynamic groups as used in the GroupTypes property of a group object
$dynamicGroupTypeString = "allstaff@sureco.com"
$groupId = "b63ccd89-48b3-4d14-8ba9-191412fd4f6c"

function ConvertStaticGroupToDynamic 
{
    $groupId = "b63ccd89-48b3-4d14-8ba9-191412fd4f6c"
    $dynamicMembershipRule = "(user.accountEnabled -eq true) and (user.department -ne null)"
    $dynamicGroupTypeString = "DynamicMembership"


  Param([string]$groupId, [string]$dynamicMembershipRule)
     $dynamicGroupTypeString = "DynamicMembership"
     #existing group types
    [System.Collections.ArrayList]$groupTypes = (Get-AzureAdMsGroup -Id $groupId).GroupTypes

     if($groupTypes -ne $null -and $groupTypes.Contains($dynamicGroupTypeString))
     {
         throw "This group is already a dynamic group. Aborting conversion.";
     }

    #existing group types
    Param([string]$groupId, [string]$dynamicMembershipRule)

    if($groupTypes -ne $null -and $groupTypes.Contains($dynamicGroupTypeString))
    {
        throw "This group is already a dynamic group. Aborting conversion.";
    }
    #add the dynamic group type to existing types
    $groupTypes.Add($dynamicGroupTypeString)

    #modify the group properties to make it a static group: i) change GroupTypes to add the dynamic type, ii) start execution of the rule, iii) set the rule
    Set-AzureAdMsGroup -Id "b63ccd89-48b3-4d14-8ba9-191412fd4f6c" -GroupTypes 0 -MembershipRuleProcessingState "On" -MembershipRule "(user.accountEnabled -eq true) and (user.department -ne null)"


}



function ConvertStaticGroupToDynamic
{
    Param([string]$groupId, [string]$dynamicMembershipRule)