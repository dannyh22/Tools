Connect-ExchangeOnline -UserPrincipalName dalvarez@sureco.com -ShowProgress $true

##ADD ALIAS
Set-UnifiedGroup -Identity "All SureCo" -EmailAddresses @{Add="salessall@sureco.com"}

##ADD PRIMARY
Set-UnifiedGroup -Identity sales -PrimarySmtpAddress salesall@sureco.com


##REMOVE ALIAS
Set-UnifiedGroup -Identity Sales -EmailAddresses @{remove='saleall@sureco.com'}


##Add Member to Group
Add-UnifiedGroupLinks -Identity "All SureCo" -LinkType Members -Links dmarkovitch@sureco.com