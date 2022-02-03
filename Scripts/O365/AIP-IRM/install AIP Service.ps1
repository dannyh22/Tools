Connect-ExchangeOnline -UserPrincipalName dalvarez@sureco.com -ShowProgress $true

##install AIP Service
Install-Module -Name AIPService

##Update AIP Service
Update-Module -Name AIPService

Set-AipServiceOnboardingControlPolicy -UseRmsUserLicense $False -SecurityGroupObjectId "d7724f97-a1f7-4113-b2e3-b23c18aca4ed"