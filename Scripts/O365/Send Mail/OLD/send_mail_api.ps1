$ClientID = "dbf46463-9128-4517-af2f-38ec3b10053c"
$ClientSecret = "TaJ7Q~aucxKf4ul7oVdb29OcO_Yannsy~vLe5"
$TenantId = "b8cd3a63-af8f-4706-8d23-a2255965baee"

$MailSender = "test.dalvarez@erieri.com"

#Connect to GRAPH API
$tokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $clientId
    Client_Secret = $clientSecret
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
                                "address": "RECIEPIENT ADDRESS"
                              }
                            }
                          ]
                        },
                        "saveToSentItems": "false"
                      }
"@

Invoke-RestMethod -Method POST -Uri $URLsend -Headers $headers -Body $BodyJsonsend