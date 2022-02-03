# Create a credential object.
$credential = Get-Credential
# Create a new secret named Secret1
Set-Secret -Name Secret1 -Secret $credential