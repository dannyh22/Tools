Connect-AzureAD
$groups=Get-AzureADGroup -All $true
$resultsarray =@()
ForEach ($group in $groups){
    $members = Get-AzureADGroupMember -ObjectId $group.ObjectId -All $true 
    ForEach ($member in $members){
       $UserObject = new-object PSObject
       $UserObject | add-member  -membertype NoteProperty -name "Group Name" -Value $group.DisplayName
       $UserObject | add-member  -membertype NoteProperty -name "Member Name" -Value $member.DisplayName
       $UserObject | add-member  -membertype NoteProperty -name "ObjType" -Value $member.ObjectType
       $UserObject | add-member  -membertype NoteProperty -name "UserType" -Value $member.UserType
       $UserObject | add-member  -membertype NoteProperty -name "UserPrinicpalName" -Value $member.UserPrincipalName
       $resultsarray += $UserObject
    }
}
$resultsarray | Export-Csv -Encoding UTF8  -Delimiter ";" -Path "C:\temp\members\members.csv" -NoTypeInformation




Connect-AzureAD
$groups=Get-AzureADGroup -All $true
ForEach ($group in $groups){
    $members = Get-AzureADGroupMember -ObjectId $group.ObjectId -All $true 
    ForEach ($member in $members){ 
        Write-output $group.DisplayName "," $member.ObjectId "," $member.ObjectType $member.UserType "," $member.UserPrincipalName >> C:\temp\members\members.csv
            }
} 