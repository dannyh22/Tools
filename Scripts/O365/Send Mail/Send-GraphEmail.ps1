function Send-GraphEmail {
    param (
        $ClientID = "dbf46463-9128-4517-af2f-38ec3b10053c",
        [Parameter(Mandatory=$true)]
        $ClientSecret,
        $TenantId = "b8cd3a63-af8f-4706-8d23-a2255965baee",
        [Parameter(Mandatory=$true)]
        $From,# test.dalvarez@erieri.com
        [Parameter(Mandatory=$true)]
        $To,
        [Parameter(Mandatory=$true)]
        $Subject,
        [Parameter(Mandatory=$true)]
        $BodyContent
    )
    begin {
    
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
        }}
    process {
        
        #Send Mail    
        $URLsend = "https://graph.microsoft.com/v1.0/users/$From/sendMail"
        $BodyJsonsend = @"
                            {
                            "message": {
                              "subject": "$Subject",
                              "body": {
                                "contentType": "HTML",
                                "content": "$BodyContent
                                "
                          },
                          "toRecipients": [
                            {
                              "emailAddress": {
                                "address": "$To"
                              }
                            }
                          ]
                        },
                        "saveToSentItems": "false"
                      }
"@
    Invoke-RestMethod -Method POST -Uri $URLsend -Headers $headers -Body $BodyJsonsend
    }
    
    end {
        #Example usage:
        #Send-GraphEmail -ClientSecret "TaJ7Q~aucxKf4ul7oVdb29OcO_Yannsy~vLe5" -MailSender "test.dalvarez@erieri.com" -RecipientAddress John.Stokes@erieri.com -Subject "Testing Testing" -BodyContent "This is the body of the email."
    }
}



$clientsecret = Read-Host -Prompt "Enter Send-Mail Secret, located in LastPass" 


Send-GraphEmail -ClientSecret $clientsecret -MailSender $currentEmailAddress -RecipientAddress $currentEmailAddress -Subject "Assessors Stage Server $newStageHostName Build Complete" -BodyContent "Stage server $newStageHostName has been built. Please allow a few minutes for it to finish configuration."