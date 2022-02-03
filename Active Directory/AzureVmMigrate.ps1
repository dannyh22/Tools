Connect-AzAccount

Set-AzContext -SubscriptionId "dc6ca423-103c-41d0-b286-1e9c8017c0ba"

#Get Resource Group of Azure Migrate Project
$ResourceGroup = Get-AzResourceGroup -Name SureCo-CA-Migration

# Get details of the Azure Migrate project
$MigrateProject = Get-AzMigrateProject -Name "NEW02-migration" -ResourceGroupName $ResourceGroup.ResourceGroupName

# View Azure Migrate project details
Write-Output $MigrateProject

# Get a specific VMware VM in an Azure Migrate project
$DiscoveredServer = Get-AzMigrateDiscoveredServer -ProjectName $MigrateProject.Name -ResourceGroupName $ResourceGroup.ResourceGroupName -DisplayName "SCSP1MDF6-SW01" | Format-Table DisplayName, Name, Type

# View discovered server details
Write-Output $DiscoveredServer
 

# Initialize replication infrastructure for the current Migrate project
Initialize-AzMigrateReplicationInfrastructure -ResourceGroupName $ResourceGroup.ResourceGroupName -ProjectName "new02-migration" -Scenario agentlessVMware -TargetRegion "westus2"