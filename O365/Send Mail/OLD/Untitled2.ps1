$securePword = Read-Host -AsSecureString

$encrypted = ConvertFrom-SecureString -SecureString $SecurePword -Key (1..16)

$encrypted | Set-Content client_secret.txt


$Pword = Get-Content client_secret.txt | ConvertTo-SecureString -Key (1..16)

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $PWord


$ClientID = "dbf46463-9128-4517-af2f-38ec3b10053c"
$TenantId = "b8cd3a63-af8f-4706-8d23-a2255965baee"

$MailSender = "test.dalvarez@erieri.com"

#Connect to GRAPH API
$tokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $clientId
    Client_Secret = $Credential
}
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token" -Method POST -Body $tokenBody
$headers = @{
    "Authorization" = "Bearer $($tokenResponse.access_token)"
    "Content-type"  = "application/json"
}

#Send Mail    
$URLsend = "https://graph.microsoft.com/v1.0/users/$MailSender/sendMail"
$BodyJsonsend = @"
                    {
                        "message": {
                          "subject": "TEST SUBJECT",
                          "body": {
                            "contentType": "HTML",
                            "content": "Hello, Daniel!
                            "
                          },
                          "toRecipients": [
                            {
                              "emailAddress": {
                                "address": "daniel.alvarez@erieri.com"
                              }
                            }
                          ]
                        },
                        "saveToSentItems": "false"
                      }
"@

Invoke-RestMethod -Method POST -Uri $URLsend -Headers $headers -Body $BodyJsonsend