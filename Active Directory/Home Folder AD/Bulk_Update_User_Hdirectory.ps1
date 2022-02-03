# Import user details from CSV
$users = Import-Csv -Path "C:\Users.csv"
 
# Iterate every row to set each user ...
foreach ($user in $users) {
    # Get the user, based on their "displayName". If you have samAccountName in you csv file,
    # you can replace displayName by samAccountName
    $userAccount = Get-ADUser -LDAPFilter ('(displayname={0})' -f $user.DisplayName);
    # Assign user's home directory path
    $homeDirectory = 'fileserverusers' + $userAccount.SamAccountName;
    # Finally set their home directory and home drive letter in Active Directory
    Set-ADUser -Identity $userAccount.SamAccountName -HomeDirectory $homeDirectory -HomeDrive H
}