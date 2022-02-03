#Get All Office 365 Groups
$O365Groups=Get-UnifiedGroup
ForEach ($Group in $O365Groups)
{
    Write-Host "Group Name:" $Group.DisplayName -ForegroundColor Green
    Get-UnifiedGroupLinks –Identity $Group.Id –LinkType Members | Select DisplayName


 
    #Get Group Members and export to CSV
    Get-UnifiedGroupLinks –Identity $Group.Id –LinkType Members | Select-Object @{Name="Group Name";Expression={$Group.DisplayName}},
         @{Name="User Name";Expression={$_.DisplayName}}, DisplayName | Export-CSV C:\temp\Members\members.csv -NoTypeInformation -Force

}


#Read more: https://www.sharepointdiary.com/2019/04/get-office-365-group-members-using-powershell.html#ixzz6YnT0im4K