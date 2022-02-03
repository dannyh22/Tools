$Params = @{
    "URI" = 'https://sureco.sharepoint.com/sites/Onboarding-Test/_api/web/lists/GetByTitle('New Employee')'
    "Method" = 'Get'
    Headers = @{
    Authentication = 'Bearer'
    }
}

Invoke-RestMethod 



GET 
Authorization: "Bearer " + accessToken
Accept: "application/json;odata=verbose"