#Connect to O365
Connect-ExchangeOnline -UserPrincipalName dalvarez@sureco.com -ShowProgress $true

#Background Color
Set-OMEConfiguration -Identity "OME Configuration" -BackgroundColor "#f5fffa"

#Logo
Set-OMEConfiguration -Identity "OME Configuration" -Image (Get-Content "C:\Temp\SureCo.png" -Encoding byte)

#introduction Text
Set-OMEConfiguration -Identity "OME Configuration" -IntroductionText "has sent you a protected message. To secure data, messages containing sensitive information will be encrypted."

#Email Text (Below Read Button)
Set-OMEConfiguration -Identity "OME Configuration" -EmailText "Encrypted message from SureCo messaging system. This email and its attachments may be confidential and are intended solely for the use of the individual to whom it is addressed."

#Portal Text
Set-OMEConfiguration -Identity "OME Configuration" -PortalText "SureCo secure email portal"

#Read Text Message
Set-OMEConfiguration -Identity "OME Configuration" -ReadButtonText "Read Encrypted Message"

#Disclaimer Text
Set-OMEConfiguration -Identity "OME Configuration" -DisclaimerText "SureCompanies, Inc. All Rights Reserved."

#Privacy Policy
Set-OMEConfiguration -Identity "OME Configuration" -PrivacyStatementUrl "https://www.sureco.com/privacy-policy"





