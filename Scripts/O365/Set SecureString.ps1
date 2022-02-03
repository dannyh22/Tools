$secure = Read-Host -AsSecureString

$encrypted = ConvertFrom-SecureString -SecureString $secure

$encrypted | Set-Content Encrypted.txt