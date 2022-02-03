#Connect to Azure
Connect-AzAccount

#MX Record
$ResourceGroup = "Infrastructure-rg"
$DomainName = "obamacare-california.com"
$MXHostName = "email"
$value1 = "inbound1.messagegears.net"
$value2 = "inbound2.messagegears.net"
$Records = @()
$Records += New-AzDnsRecordConfig -Exchange $value1 -preference 10
$Records += New-AzDnsRecordConfig -Exchange $value2 -preference 10

New-AzDnsRecordSet -Name $MXHostName -RecordType MX -ResourceGroupName $ResourceGroup -TTL 3600 -ZoneName $DomainName -DnsRecords $Records

#Create @ TXT Record New
#Verify if @ TXT record already exists!!!#
$ResourceGroup = "Infrastructure-rg"
$TXTHostName = "@"
$value1 = "v=spf1 include:_spf.messagegears.net -all"
$Records = New-AzDnsRecordConfig -Value $value1

New-AzDnsRecordSet -Name $TXTHostName -RecordType TXT -ResourceGroupName $ResourceGroup -TTL 3600 -ZoneName $DomainName -DnsRecords $Records

#Create Txt Records SubDomain 2
$ResourceGroup = "Infrastructure-rg"
$TXTHostName = "email"
$value1 = "v=spf1 include:_spf.messagegears.net -all"
$value2 = "spf2.0/pra include:_auth.messagegears.net -all"
$Records = @()
$Records += New-AzDnsRecordConfig -value $value1 
$Records += New-AzDnsRecordConfig -value $value2

New-AzDnsRecordSet -Name $TXTHostName -RecordType TXT -ResourceGroupName $ResourceGroup -TTL 3600 -ZoneName $DomainName -DnsRecords $Records


#Create Txt Records SubDomain gears._domainkey
$ResourceGroup = "Infrastructure-rg"
$TXTHostName = "gears._domainkey"
$value1 = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnnZ67teJIQQLcfbzztAOx7UMJyFVpz29RX1ZlrV9xf5yJDQyCMCHcwcN5qNaqLMr/cuVzkSW3e1vYqO/9lqfXWkXSgYM8kVeywfubh07vNxTia/5pggiiCPD0+wgSgrMqJFDoKzzFAf+wWwidaHQ9Q9Zel0+w9gWmsi56xt7mRwIDAQAB"
$Records = @()
$Records += New-AzDnsRecordConfig -value $value1 

New-AzDnsRecordSet -Name $TXTHostName -RecordType TXT -ResourceGroupName $ResourceGroup -TTL 3600 -ZoneName $DomainName -DnsRecords $Records

#Create Txt Records SubDomain gears._domainkey.email
$ResourceGroup = "Infrastructure-rg"
$TXTHostName = "gears._domainkey.email"
$value1 = "k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnnZ67teJIQQLcfbzztAOx7UMJyFVpz29RX1ZlrV9xf5yJDQyCMCHcwcN5qNaqLMr/cuVzkSW3e1vYqO/9lqfXWkXSgYM8kVeywfubh07vNxTia/5pggiiCPD0+wgSgrMqJFDoKzzFAf+wWwidaHQ9Q9Zel0+w9gWmsi56xt7mRwIDAQAB"
$Records = @()
$Records += New-AzDnsRecordConfig -value $value1 

New-AzDnsRecordSet -Name $TXTHostName -RecordType TXT -ResourceGroupName $ResourceGroup -TTL 3600 -ZoneName $DomainName -DnsRecords $Records

#Create TXT Records Subdomain _domainkey.email
$ResourceGroup = "Infrastructure-rg"
$TXTHostName = "_domainkey.email"
$value1 = "o=-;"
$Records = @()
$Records += New-AzDnsRecordConfig -value $value1 

New-AzDnsRecordSet -Name $TXTHostName -RecordType TXT -ResourceGroupName $ResourceGroup -TTL 3600 -ZoneName $DomainName -DnsRecords $Records

#Create CNAME Record
$ResourceGroup = "Infrastructure-rg"
$CName = "link"
$value1 = "elink.clickdimensions.com"
$Records = @()
$Records += New-AzDnsRecordConfig -cname $value1 

New-AzDnsRecordSet -Name $CName -RecordType CNAME -ResourceGroupName $ResourceGroup -TTL 3600 -ZoneName $DomainName -DnsRecords $Records