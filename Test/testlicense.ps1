function Set-License {
    param (
        $ClientID = "165e07b2-50ba-4654-920b-d5b87daeca46c",
        [Parameter(Mandatory=$true)]
        $ClientSecret = "Ada7Q~N5KfM8C63TylFjvs7lc_TDwUd7xnzn5",
        [Parameter(Mandatory=$true)]
        $TenantId = "b8cd3a63-af8f-4706-8d23-a2255965baee",
        [Parameter(Mandatory=$true)]
        $UPN,# test.dalvarez@erieri.com
        [Parameter(Mandatory=$true)]
        $Body
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
        
        #AssignLicense
        $URLsend = "https://graph.microsoft.com/v1.0/users/$UPN/assignlicense"
        $Body = @{
            addLicenses = @(
                @{
                disabledPlans = @()
                skuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3"
                }
            )
            removeLicenses = @()
        }
    Invoke-RestMethod -Method POST -Uri $URLsend -Headers $headers -Body $Body
    }
    
    end {
        #Example usage:
        #Send-GraphEmail -ClientSecret  -MailSender "test.dalvarez@erieri.com" -RecipientAddress John.Stokes@erieri.com -Subject "Testing Testing" -BodyContent "This is the body of the email."
    }
}