Connect-ExchangeOnline -Credential dalvarez@sureco.com

$identity = "Healthrive"

#Logo
Set-OMEConfiguration -Identity $identity -BackgroundColor "#ffffff" -Image (Get-Content "C:\Temp\healthrive.png" -Encoding byte)

#introduction Text
Set-OMEConfiguration -Identity $identity -IntroductionText "has sent you a secured encrypted email. This email and its attachments may be confidential and are intended solely for the use of the individual to whom it is addressed."

#Email Text (Below Read Button)
Set-OMEConfiguration -Identity $identity -EmailText "This is an unmonitored inbox, please contact concierge@ihealthrive.com for assistance."

#Portal Text
Set-OMEConfiguration -Identity $identity -PortalText "iHealthrive secure email portal"

#Read Text Message
Set-OMEConfiguration -Identity $identity -ReadButtonText "Open Secure Email"

#Disclaimer Text
Set-OMEConfiguration -Identity $identity -DisclaimerText "iHealthrive All Rights Reserved."

#Privacy Policy
Set-OMEConfiguration -Identity $identity -PrivacyStatementUrl "https://www.ihealthrive.com/disclaimer/"