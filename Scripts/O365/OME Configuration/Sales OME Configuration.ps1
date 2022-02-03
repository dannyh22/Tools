#Connect to O365
Connect-ExchangeOnline -UserPrincipalName dalvarez@sureco.com -ShowProgress $true

$identity = "Sales esign Configuration"

#Create New OME Template
New-OMEConfiguration -Identity $identity

Set-OMEConfiguration -Identity $identity -BackgroundColor "#f5fffa" -Image (Get-Content "C:\Temp\SureCo.png" -Encoding byte)

#introduction Text
Set-OMEConfiguration -Identity $identity -IntroductionText "has sent your protected signed documents. To secure your data, messages and/or attachments containing sensitive information will be encrypted."

#Email Text (Below Read Button)
Set-OMEConfiguration -Identity $identity -EmailText "Encrypted message from SureCo messaging system. This email and its attachments may be confidential and are intended solely for the use of the individual to whom it is addressed."

#Portal Text
Set-OMEConfiguration -Identity $identity -PortalText "SureCo secure email portal"

#Read Text Message
Set-OMEConfiguration -Identity $identity -ReadButtonText "Access Documents"

#Disclaimer Text
Set-OMEConfiguration -Identity $identity -DisclaimerText "SureCompanies, Inc. All Rights Reserved."

#Privacy Policy
Set-OMEConfiguration -Identity $identity -PrivacyStatementUrl "https://www.sureco.com/privacy-policy"

