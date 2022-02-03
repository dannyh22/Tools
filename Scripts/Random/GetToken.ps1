# Values shown below are randomly generated, but will need to reflect your environment
$TenantID = 'f82bd569-15bf-4ed7-8826-f1bbf3b3fb53' 
$ClientID = '94d308a3-0bc7-4a6e-a3fd-ebfd3506bb91'
$ClientSecret = '.q6GO~~A444x07_Jl52xtMFmFdku6xb4jj'


$Params = @{
    "URI"         = "https://login.microsoftonline.com/$TenantID/oauth2/token"
    "Body"        = "client_id=$ClientID&scope=https%3A%2F%2Fgraph.microsoft.com%2F.default&client_secret=$ClientSecret&grant_type=client_credentials"
    "Method"      = 'GET'
    "Headers"     = @{
    "ContentType" = 'application/x-www-form-urlencoded'
 }
}

$Result = Invoke-RestMethod $Params
