##Connect to Azure
Connect-AzureRmAccount


#Create New AZ DNS Zone
Import-Csv C:\temp\domains.csv | foreach {New-AzureRmDnsZone -Name $_.name -ResourceGroupName infrastructure-rg}


