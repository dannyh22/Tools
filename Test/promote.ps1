#Requires -Modules AWSPowerShell

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [String]
    $AWSProfileName,
    [Parameter(Mandatory = $true)]
    [PSCredential]
    $Credential
)

#region Setup
Start-Transcript \\snapvfile1\Share\Deployments\online.erieri.com\Logging\Assessor_log.txt
Initialize-AWSDefaults -ProfileName $AWSProfileName -Region 'us-west-2'
$date = Get-Date -Format "MM-dd-yy"
$stagePublicIP = "54.148.53.32"
$prodPublicIP = "54.201.45.116"
#endregion Setup

#region GatherAWS
#region ProdPendingServer
# Find the current prod pending server, filtering by tag Site, tag Status, and instance state != 'terminated' or 'stopped'
$ec2ProdPendingInstanceArgs = @{
    Filter = @(@{Name = 'tag:Site'; Value = 'ASSESSORS' }, @{Name = 'tag:Status'; Value = 'PROD PENDING' })
}
$prodPendingServerList = Get-EC2Instance @ec2ProdPendingInstanceArgs |
    Select-Object -ExpandProperty 'Instances'
$prodPendingServer = $prodPendingServerList |
    Where-Object { ($_.State.Name -ne 'terminated') -and ($_.State.Name -ne 'stopped') }

if ($prodPendingServer.Length -ne 1) {
    throw "Expected 1 Prod Pending Assessors server (non-terminated, non-stopped) but found $($prodPendingServer.Length) - please check AWS console"
}
#endregion ProdPendingServer

#region CurrentProdServer
# Find the current prod server, filtering by tag Site, tag Status, and instance state != 'terminated' or 'stopped'
$ec2CurrentProdInstanceArgs = @{
    Filter = @(@{Name = 'tag:Site'; Value = 'ASSESSORS' }, @{Name = 'tag:Status'; Value = 'PROD' })
}
$currentProdServerList = Get-EC2Instance @ec2CurrentProdInstanceArgs |
    Select-Object -ExpandProperty 'Instances'
$currentProdServer = $currentProdServerList |
    Where-Object { ($_.State.Name -ne 'terminated') -and ($_.State.Name -ne 'stopped') }

if ($currentProdServer.Length -ne 1) {
    throw "Expected 1 Prod Assessors server (non-terminated, non-stopped) but found $($currentProdServer.Length) - please check AWS console"
}
#endregion CurrentProdServer

#region StageServer
# Find the new stage server, filtering by tag Site, tag Status, and instance state != 'terminated' or 'stopped'
$ec2NewStageInstanceArgs = @{
    Filter = @(@{Name = 'tag:Site'; Value = 'ASSESSORS' }, @{Name = 'tag:Status'; Value = 'STAGE' })
}
$newStageServerList = Get-EC2Instance @ec2NewStageInstanceArgs |
    Select-Object -ExpandProperty 'Instances'
$newStageServer = $newStageServerList |
    Where-Object { ($_.State.Name -ne 'terminated') -and ($_.State.Name -ne 'stopped') }

if ($newStageServer.Length -ne 1) {
    throw "Expected 1 Stage Assessors server (non-terminated, non-stopped) but found $($newStageServer.Length) - please check AWS console"
}
#endregion StageServer

$newProdInstanceID = $prodPendingServer.InstanceId
$newProdHostName = $prodPendingServer.Tags | Where-Object { $_.Key -eq 'HostName' } | Select-Object -ExpandProperty 'Value'
$newProdDisplayName = "$newProdHostName *PROD*"
$newProdPrivateIpAddress = $prodPendingServer.PrivateIpAddress

Write-Output "newProdInstanceID = $newProdInstanceID"
Write-Output "newProdDisplayName = $newProdDisplayName"

$oldProdInstanceID = $currentProdServer.InstanceId
$oldProdHostName = $currentProdServer.Tags | Where-Object { $_.Key -eq 'HostName' } | Select-Object -ExpandProperty 'Value'
$oldProdDisplayName = "$oldProdHostName *SUNSET - $date*"

Write-Output "oldProdInstanceID = $oldProdInstanceID"
Write-Output "oldProdDisplayName = $oldProdDisplayName"

$stageInstanceID = $newStageServer.InstanceId
$stageHostName = $newStageServer.Tags | Where-Object { $_.Key -eq 'HostName' } | Select-Object -ExpandProperty 'Value'
$stageDisplayName = $newStageServer.Tags | Where-Object { $_.Key -eq 'Name' } | Select-Object -ExpandProperty 'Value'
$stagePrivateIpAddress = $newStageServer.PrivateIpAddress

Write-Output "stageInstanceID = $stageInstanceID"
Write-Output "stageDisplayName = $stageDisplayName"

# Get AWS Association/Allocation IDs used for Elastic IPs
Write-Output "Get AWS Association/Allocation IDs used for Elastic IPs"
$stageElasticIPAssociationID = (Get-EC2Address -PublicIP $stagePublicIP).AssociationId
$stageElasticIPAllocationID = (Get-EC2Address -PublicIP $stagePublicIP).AllocationId
$prodElasticIPAssociationID = (Get-EC2Address -PublicIP $prodPublicIP).AssociationId
$prodElasticIPAllocationID = (Get-EC2Address -PublicIP $prodPublicIP).AllocationId
#endregion GatherAWS

Write-Warning -Message "The following changes will be made. Enter [Q/q] to quit if changes are incorrect; enter any other key to make changes."
Write-Output "Elastic IP [$prodPublicIP] with association ID [$prodElasticIPAssociationID] will be unregistered"
Write-Output "[$oldProdHostName] with instance ID [$oldProdInstanceID] will have its 'Name' tag changed to [$oldProdDisplayName]"
Write-Output "[$oldProdHostName] with instance ID [$oldProdInstanceID] will have its 'Status' tag removed"
Write-Output "Elastic IP [$stagePublicIP] with association ID [$stageElasticIPAssociationID] will be unregistered"
Write-Output "[$newProdHostName] with instance ID [$newProdInstanceID] will have Elastic IP [$prodPublicIP] registered"
Write-Output "[$newProdHostName] with instance ID [$newProdInstanceID] will have its 'Name' tag changed to [$newProdDisplayName]"
Write-Output "[$newProdHostName] with instance ID [$newProdInstanceID] will have its 'Status' tag changed to [PROD]"
Write-Output "[$stageHostName] with instance ID [$stageInstanceID] will have Elastic IP [$stagePublicIP] registered"

$response = Read-Host -Prompt 'Enter Q for Quit or press Enter'
if ($response.ToLower() -eq 'q') {
    Stop-Transcript
    Write-Warning -Message "Aborting."
    exit
}

# Unregister Prod Elastic IP address from old Prod
Write-Warning -Message "Unregistering public Prod IP address [$prodPublicIP]"
Unregister-EC2Address -AssociationId $prodElasticIPAssociationID

# Update Name tag for old Prod
Write-Output "Updating AWS 'Name' tag on old Prod server [$oldProdHostName] to reflect new sunset status [$oldProdDisplayName]"
New-EC2Tag -Resource $oldProdInstanceID -Tag @{ Key = "Name"; Value = "$oldProdDisplayName" }

# Remove Status tag for old Prod
Write-Output "Removing AWS 'Status' tag on old Prod server [$oldProdHostName]"
New-EC2Tag -Resource $oldProdInstanceID -Tag @{ Key = "Status"; Value = "" }

# Unregister Stage Elastic IP address from Prod Pending
Write-Warning -Message "Unregistering public Stage IP address [$stagePublicIP]"
Unregister-EC2Address -AssociationId $stageElasticIPAssociationID

# Register Prod Elastic IP address with Prod Pending (now Prod)
Write-Warning -Message "Registering public Prod IP address [$prodPublicIP] on Prod Pending (now Prod) server [$newProdHostName]"
Register-EC2Address -InstanceId $newProdInstanceID -AllocationId $prodElasticIPAllocationID

# Update Name tag for Prod
Write-Output "Updating AWS 'Name' tag on new Prod server [$newProdHostName] to [$newProdDisplayName]"
New-EC2Tag -Resource $newProdInstanceID -Tag @{ Key = "Name"; Value = "$newProdDisplayName" }

# Update Status tag for Prod
Write-Output "Updating AWS 'Status' tag on new Prod server [$newProdHostName] to [PROD]"
New-EC2Tag -Resource $newProdInstanceID -Tag @{ Key = "Status"; Value = "PROD" }

# Register Stage Elastic IP
Write-Warning -Message "Registering public Stage IP address [$stagePublicIP] with new Stage server [$stageHostName]"
Register-EC2Address -InstanceId $stageInstanceID -AllocationId $stageElasticIPAllocationID

Write-Warning -Message "Check AWS console and Assessors to confirm that changes have been made successfully. Press Enter once confirmed."
$null = Read-Host -Prompt 'Press Enter'

$dcList = @('SNAPSDC01','CO1-SDC1','CO1-VDC2','SNAPVDC2')
# Change internal DNS A records for online.erieri.local
# Must be done without removing since it's a delegation for other records
foreach ($dc in $dcList) {
    try {
        $dcCimSession = New-CimSession -ComputerName $dc -Credential $Credential
        $oldDnsRecord = Get-DnsServerResourceRecord -CimSession $dcCimSession -Name 'online' -ZoneName 'erieri.local' -RRType A |
            Where-Object {$_.HostName -eq 'online'}
        $newDnsRecord = $oldDnsRecord.Clone()

        $newDnsRecord.RecordData.IPv4Address = [System.Net.IPAddress]::Parse($newProdPrivateIpAddress)

        Set-DnsServerResourceRecord -CimSession $dcCimSession -NewInputObject $newDnsRecord -OldInputObject $oldDnsRecord -ZoneName 'erieri.local'
        Remove-CimSession -CimSession $dcCimSession
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

# Change internal DNS A records for stage.online.erieri.local
# Can be done by removing and re-adding for simplicity
foreach ($dc in $dcList) {
    try {
        $dcCimSession = New-CimSession -ComputerName $dc -Credential $Credential
        Get-DnsServerResourceRecord -CimSession $dcCimSession -Name 'stage.online' -ZoneName 'erieri.local' -RRType A |
            Remove-DnsServerResourceRecord -CimSession $dcCimSession -ZoneName 'erieri.local' -Force
        Add-DnsServerResourceRecordA -CimSession $dcCimSession -Name 'stage.online' -ZoneName 'erieri.local' -IPv4Address $stagePrivateIpAddress
        Remove-CimSession -CimSession $dcCimSession
    }

    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
}

$body = "<HTML><HEAD><META http-equiv=""Content-Type"" content=""text/html; charset=iso-8859-1"" /><TITLE></TITLE></HEAD>"
$body += "<BODY bgcolor=""#FFFFFF"" style=""font-size: Small; font-family: TAHOMA; color: #000000""><P>"
$body += "<b><font color=red>Assessor Prod Push complete.  Please test. <a href=https://online.erieri.com target=""_blank"">https://online.erieri.com</a> </b></font><br>"

$mailArgs = @{
    SmtpServer = 'd188133a.ess.barracudanetworks.com'
    To         = 'online.assessor.notifications@erieri.com'
    From       = 'online.assessor.notifications@erieri.com'
    Credential = $Credential
    UseSsl     = $true
    Port       = 587
    Subject    = "Assessors Prod Push Complete"
    Body       = $body
    BodyAsHtml = $true
    Priority   = 'High'
}
Send-MailMessage @mailArgs

Stop-Transcript