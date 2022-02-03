Connect-MicrosoftTeams

#Assign Multiple Phone Numbers
Import-Csv C:\test\numbers.csv | ForEach-Object {Set-CsOnlineVoiceUser -identity $_.identity -TelephoneNumber $_.TelephoneNumber -LocationID $_.LocationID}