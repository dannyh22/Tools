Connect-ExchangeOnline -UserPrincipalName dalvarez@sureco.com -ShowProgress $true

$displayname = 'DL-Healthrive UM'
$name = $displayname
$PSA = 'dl-healthriveum@sureco.com'
$alias = 'healthriveum@sureco.com'
$owner = 'jkim@sureco.com'

New-DistributionGroup -DisplayName $displayname -Name $name -PrimarySmtpAddress $PSA -MemberDepartRestriction Closed -ManagedBy $owner, 'dalvarez@sureco.com'

Import-Csv C:\temp\test.csv | foreach {Add-DistributionGroupMember -Identity $PSA -Member $_.userprincipalname}



##ADD ALIAS
Set-DistributionGroup -Identity $displayname -EmailAddresses @{Add= $alias}

##ADD PRIMARY SMTP
Set-DistributionGroup -Identity $displayname -PrimarySmtpAddress dl-uhsmmemberservices@sureco.com

##REMOVE ALIAS
Set-DistributionGroup -Identity $displayname -EmailAddresses @{remove='dl-salesagents@sureco.com'}






