$TenantID = "f82bd569-15bf-4ed7-8826-f1bbf3b3fb53"
$ClientID = "94d308a3-0bc7-4a6e-a3fd-ebfd3506bb91"
$ClientSecret = ".q6GO~~A444x07_Jl52xtMFmFdku6xb4jj"


$Params = @{
"URI" = "https://login.microsoftonline.com/$tenantID/oauth2/v2.0/token"
"Body" = "client_id=$ClientID&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default&client_secret=$ClientSecret&grant_type=client_credentials"
"Method" = 'Post'
"Headers" = @{
"Content-Type" = 'application/x-www-form-urlencoded'
}
}

$Result = Invoke-RestMethod @Params

Params2 = @{
    "URI" = "https://graph.microsoft.com/v1.0/sites/8b658dd0-5ca3-48bb-9cad-b7dc3cf840fe/lists/9a414f6d-da25-4172-a9c5-89f17d436389?expand=columns,items(expand=fields)"
    "Method" = 'GET'
    "Authentication" = 'OAUTH'
    "Token" = (ConvertTo-SecureString -String $Result.access_token -AsPlainText -Force)
    "Body" = @{
        &grant_type=client_credentials 
        &client_id = $ClientID 
        &client_secret = $ClientSecret

    }
}





$NewHires = Invoke-RestMethod 

$NewHires.value | Select-Object FirstName,LastName,Status | Format-Table -AutoSize



