#Connect to Azure
Connect-AzAccount

$resourceGroupName = "sureco-dynamics-datafactory-v2-rg"
$serverName = "sureco-dynamics-datafactory-v2-server"
$databaseName = "ReportServerTempDB"


set-AzSqlDatabase -ResourceGroupName $resourceGroupName -ServerName $serverName -DatabaseName $databaseName -ComputeModel Serverless -Edition GeneralPurpose -ComputeGeneration Gen5 -MinVcore 0.5 -MaxVcore 2 -AutoPauseDelayInMinutes 1040

Get-AzSqlDatabase -ResourceGroupName $resourcegroupname -ServerName $servername -DatabaseName $databasename | Select -ExpandProperty "Status"