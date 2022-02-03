# Values shown below are randomly generated, but will need to reflect your environment
$TenantID = 'f82bd569-15bf-4ed7-8826-f1bbf3b3fb53' 
$ClientID = '94d308a3-0bc7-4a6e-a3fd-ebfd3506bb91'
$ClientSecret = '.q6GO~~A444x07_Jl52xtMFmFdku6xb4jj'
 
$Params = @{
 "URI"     = "https://login.microsoftonline.com/$TenantID/oauth2/token"
 "Body"    = "client_id=$ClientID&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default&client_secret=$ClientSecret&grant_type=client_credentials"
 "Method"  = 'GET'
 "Headers" = @{
    "Content-Type" = 'application/x-www-form-urlencoded'
    }
}
 
$Result = Invoke-RestMethod @Params
 
$Params3 = @{
"URI"            = "https://graph.microsoft.com/v1.0/sites/8b658dd0-5ca3-48bb-9cad-b7dc3cf840fe/lists/9a414f6d-da25-4172-a9c5-89f17d436389?expand=columns,items(expand=fields)"
"Method"         = 'GET'
"Authentication" = 'OAuth'
"Token"          = (ConvertTo-SecureString -String $Result.access_token -AsPlainText -Force)
"Body"           = @{
    "&client_id"  = $ClientID 
    "&client_secret" = $ClientSecret
   }
}
 
$Members = Invoke-RestMethod @Params3
 
$Members.Value = @{ Select-Object FirstName,LastName,JobTitle | Format-Table -AutoSize }


