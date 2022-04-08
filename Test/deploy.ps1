#Requires -Modules 'AWSPowerShell'

[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)]
    [String]
    $AWSProfileName,
    [Parameter(Mandatory = $true)]
    [PSCredential]
    $Credential
)

# TODO: Copy certs to drive from file share
# TODO: Run Harden-IIS

#region Setup
try {
    Initialize-AWSDefaults -ProfileName $AWSProfileName -Region 'us-west-2' -ErrorAction 'Stop'
}
catch {
    $PSCmdlet.ThrowTerminatingError($_)
}
#endregion Setup

#region Find Current Stage Server
# Find the current stage server, filtering by tag Site, tag Status, and instance state != 'terminated' or 'stopped'
$ec2InstanceArgs = @{
    Filter = @(@{Name = 'tag:Site'; Value = 'ASSESSORS' }, @{Name = 'tag:Status'; Value = 'STAGE' })
}
$currentStageServerList = Get-EC2Instance @ec2InstanceArgs |
    Select-Object -ExpandProperty 'Instances'
$currentStageServer = $currentStageServerList |
    Where-Object { ($_.State.Name -ne 'terminated') -and ($_.State.Name -ne 'stopped') }

if ($currentStageServer.Length -ne 1) {
    throw "Only expected 1 Stage Assessors server (non-terminated, non-stopped) but found $($currentStageServer.Length) - please check AWS console"
}
#endregion Find Current Stage Server

#region NewHostname
$hostNameRegex = '^AOR-IIS-AO(\d+)$'

$currentStageHostName = $currentStageServer.Tags |
    Where-Object { $_.Key -eq 'HostName' } |
        Select-Object -ExpandProperty 'Value'

if ($currentStageHostName -match $hostNameRegex) {
    $currentStageHostNameSuffix = [int]$Matches[1]
    $newStageHostNameSuffix = $currentStageHostNameSuffix + 1
} else {
    throw 'No host name could be matched against the regex.'
}

$newStageHostName = "AOR-IIS-AO{0}" -f $newStageHostNameSuffix.ToString()
Write-Verbose -Message "New stage server hostname is [$newStageHostName]" -Verbose
#endregion NewHostname

#region Volumes
Write-Verbose -Message "Creating new primary EBS volume for [$newStageHostName]" -Verbose
$rootVolume = New-Object Amazon.EC2.Model.EbsBlockDevice
$rootVolume.VolumeSize = 70
$rootVolume.VolumeType = 'standard'
$rootVolume.DeleteOnTermination = $true

$rootVolumeDeviceMapping = New-Object Amazon.EC2.Model.BlockDeviceMapping
$rootVolumeDeviceMapping.DeviceName = '/dev/sda1'
$rootVolumeDeviceMapping.Ebs = $rootVolume

$dataVolumeName = 'xvdf'

Write-Verbose -Message "Identifying secondary $dataVolumeName volume on stage server" -Verbose

$currentStageServerDataVolume = $currentStageServer |
    Select-Object -ExpandProperty 'BlockDeviceMappings' |
        Where-Object { $_.DeviceName -eq $dataVolumeName }
$currentStageServerDataVolumeId = $currentStageServerDataVolume |
    Select-Object -ExpandProperty 'Ebs' |
        Select-Object -ExpandProperty 'VolumeId'
Write-Verbose -Message "VolumeId is [$currentStageServerDataVolumeId]" -Verbose

Write-Verbose -Message "Creating snapshot of VolumeId [$currentStageServerDataVolumeId]" -Verbose
$date = Get-Date -Format 'FileDate'
$snapshotArgs = @{
    VolumeId    = $currentStageServerDataVolumeId
    Description = "Snapshot of $currentStageHostName volume $dataVolumeName on $date"
}
$snapshot = New-EC2Snapshot @snapshotArgs
Write-Verbose -Message "Snapshot with ID of [$($snapshot.SnapshotId)] has been created" -Verbose
New-EC2Tag -Resource $snapshot.SnapshotId -Tag @{ Key = 'Name'; Value = "$currentStageHostName - $date" }

Write-Verbose -Message "Waiting for state of snapshot [$($snapshot.SnapshotId)] to be completed" -Verbose
while ((Get-EC2Snapshot -SnapshotId $snapshot.SnapshotId).State.Value -notlike 'completed') {
    Write-Output '.'
    Start-Sleep -Seconds 3
}

Write-Verbose -Message "Creating new $dataVolumeName data volume BlockDeviceMapping based on snapshot [$($snapshot.SnapshotId)]" -Verbose
$dataVolume = New-Object Amazon.EC2.Model.EbsBlockDevice
$dataVolume.VolumeType = 'standard'
$dataVolume.DeleteOnTermination = $true
$dataVolume.SnapshotId = $snapshot.SnapshotId
$dataVolume.VolumeSize = $snapshot.VolumeSize

$dataVolumeDeviceMapping = New-Object Amazon.EC2.Model.BlockDeviceMapping
$dataVolumeDeviceMapping.DeviceName = $dataVolumeName
$dataVolumeDeviceMapping.Ebs = $dataVolume
#endregion Volumes

#region Deploy
$instanceType = 'r3.xlarge'
$keyName = 'AWS-ERI-IIS'
$region = 'us-west-2'
$script = 'Assessors'
$securityGroupID = 'sg-16abc973'
$instanceProfileName = 'EC2DomainJoin'
$subnetId = 'subnet-a68ea4d2'
$availabilityZone = 'us-west-2a'
$userData = @"
<powershell>
Start-Transcript -Path 'C:\build_env_$($script)_log.txt'
Get-Disk | Where-Object {`$_.OperationalStatus -eq 'Offline'} | ForEach-Object -Process {Set-Disk -Number `$_.Number -IsOffline `$false}
Get-Disk | Where-Object {`$_.IsReadOnly -eq `$true} | ForEach-Object -Process {Set-Disk -Number `$_.Number -IsReadOnly `$false}
takeown.exe /f D:\ /A /R /d Y
Set-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv4-In)' -Enabled 'True' -Profile 'Any' -Action 'Allow'
Rename-Computer -NewName '$newStageHostName' -Force
Stop-Transcript
</powershell>
"@

Write-Verbose -Message 'Getting AMI with name WINDOWS_2016_BASE' -Verbose
$ami = Get-EC2ImageByName -Name 'WINDOWS_2016_BASE'
Write-Verbose -Message "AMI found with ID [$($ami.ImageId)] and name [$($ami.Name)]" -Verbose

$instanceArgs = @{
    ImageId              = $ami.ImageId
    KeyName              = $keyName
    SecurityGroupID      = $securityGroupID
    InstanceType         = $instanceType
    InstanceProfile_Name = $instanceProfileName
    MinCount             = 1
    MaxCount             = 1
    SubnetId             = $subnetId
    UserData             = $userData
    EncodeUserData       = $true
    BlockDeviceMapping   = @($rootVolumeDeviceMapping, $dataVolumeDeviceMapping)
    AvailabilityZone     = $availabilityZone
}

Write-Verbose -Message 'Creating new instance on AWS' -Verbose
$newInstanceReservation = New-EC2Instance @instanceArgs
$newInstance = $newInstanceReservation.Instances[0]
Write-Verbose -Message "Instance created with ID [$($newInstance.InstanceId)]" -Verbose
Write-Verbose -Message "Private IP address is [$($newInstance.PrivateIpAddress)]" -Verbose

$instanceTags = @(
    @{key = 'Name'; value = "$newStageHostName *STAGE*" }
    @{key = 'CreatedBy'; value = "$env:USERNAME" }
    @{key = 'Status'; value = 'STAGE' }
    @{key = 'HostName'; value = "$newStageHostName" }
    @{key = 'Site'; value = 'ASSESSORS' }
)
New-EC2Tag -Resource $newInstance.InstanceId -Region $region -Tag $instanceTags

$null = New-SSMAssociation -InstanceId $newInstance.InstanceId -Name 'awsconfig_Domain_d-9267270f57_aws.erieri.local'
Write-Verbose -Message "New Assessors stage server [$newStageHostName] created" -Verbose

Write-Verbose -Message "Waiting for [$newStageHostName] to become available for remote access" -Verbose
while (-not (Test-Connection -ComputerName $newStageHostName -Count 1 -ErrorAction 'SilentlyContinue')) {
    Write-Output "[$newStageHostName] is not yet available. Sleeping 3 seconds."
    Start-Sleep -Seconds 3
}

#region Certificates
Write-Verbose -Message "Copying certs to [$newStageHostName]" -Verbose
try {
    $certPath = Resolve-Path -Path '..\Certs'
    $serverPSSession = New-PSSession -ComputerName $newStageHostName -Credential $Credential -ErrorAction 'Stop'
    Invoke-Command -Session $serverPSSession -ScriptBlock {New-Item -Path 'C:\' -Name 'Certs' -ItemType Directory -Force | Out-Null}
    Copy-Item -Path "$certPath\*" -Destination 'C:\Certs' -Recurse -Force -ToSession $serverPSSession
    Remove-PSSession -Session $serverPSSession
}
catch {
    $PSCmdlet.ThrowTerminatingError($_)
}
#endregion Certificates

#region Stage DSC SSM Association
$dscAssociationArgs = @{
    AssociationName = "DSC_Assessors_Stage_$newStageHostName"
    Target = @(
        @{
            Key = 'InstanceIds'
            Values= @($newInstance.InstanceId)
        }
    )
    Name = 'AWS-ApplyDSCMofs'
    Parameter = @{
        MofsToApply = 's3:us-west-2:eri-dsc-mofs:ERI-Assessors-Stage-SSM-Config.mof'
        ServicePath = 'awsdsc'
        MofOperationMode = 'Apply'
        ReportBucketName = 'us-west-2:eri-dsc-reports'
        StatusBucketName = 'us-west-2:eri-dsc-status'
        ModuleSourceBucketName = 'NONE'
        AllowPSGalleryModuleSource = 'True'
        ProxyUri = ''
        RebootBehavior = 'AfterMof'
        UseComputerNameForReporting = 'True'
        EnableVerboseLogging = 'False'
        EnableDebugLogging = 'False'
        ComplianceType = 'Custom:DSC'
        PreRebootScript = ''
    }
    ScheduleExpression = 'cron(0 0 */12 * * ? *)'
}
$null = New-SSMAssociation @dscAssociationArgs
Write-Verbose -Message "Stage Assessors DSC association for [$newStageHostName] created" -Verbose
#endregion Stage DSC SSM Association

#region NSClient++
Write-Verbose -Message "Installing NSClient++, VisualStudioRedistPackages and DotNetFramework4.8 on [$newStageHostName]" -Verbose
try {
    $serverPSSession = New-PSSession -ComputerName $newStageHostName -Credential $Credential -ErrorAction 'Stop'
    Invoke-Command -Session $serverPSSession -ScriptBlock {New-Item -Path 'C:\temp' -Name 'NSClientFiles' -ItemType Directory -Force | Out-Null}
    Copy-Item -Path '\\snapitutil1\Apps\Application Installs\Nagios Client\*' -Destination 'C:\temp\NSClientFiles' -Recurse -Force -ToSession $serverPSSession
    Invoke-Command -Session $serverPSSession -ScriptBlock {Start-Process -FilePath 'C:\temp\NSClientFiles\NSCP-0.5.2.35-x64.msi' -ArgumentList '/quiet', '/norestart' -Wait}
    Invoke-Command -Session $serverPSSession -ScriptBlock {Copy-Item -Path 'C:\temp\NSClientFiles\nsclient.ini' -Destination 'C:\Program Files\NSClient++\nsclient.ini' -Force}
    Invoke-Command -Session $serverPSSession -ScriptBlock {New-Item -Path 'C:\temp' -Name 'VisualStudioRedistPackages' -ItemType Directory -Force | Out-Null}
	Copy-Item -Path '\\snapitutil1\Apps\Application Installs\VisualStudioRedistPackages\*' -Destination 'C:\temp\VisualStudioRedistPackages' -Recurse -Force -ToSession $serverPSSession
    Invoke-Command -Session $serverPSSession -ScriptBlock {Start-Process -FilePath 'C:\temp\VisualStudioRedistPackages\VC_redist.x64.exe' -ArgumentList '/quiet', '/norestart' -Wait}
	Invoke-Command -Session $serverPSSession -ScriptBlock {Start-Process -FilePath 'C:\temp\VisualStudioRedistPackages\VC_redist.x86.exe' -ArgumentList '/quiet', '/norestart' -Wait}
	Copy-Item -Path '\\snapitutil1\Apps\Application Installs\VisualStudioRedistPackages\*' -Destination 'C:\temp\VisualStudioRedistPackages' -Recurse -Force -ToSession $serverPSSession
	Invoke-Command -Session $serverPSSession -ScriptBlock {New-Item -Path 'C:\temp' -Name 'DotNetFramework4.8' -ItemType Directory -Force | Out-Null}
	Copy-Item -Path '\\snapitutil1\Apps\Application Installs\DotNetFramework4.8\*' -Destination 'C:\temp\DotNetFramework4.8' -Recurse -Force -ToSession $serverPSSession
	Invoke-Command -Session $serverPSSession -ScriptBlock {Start-Process -FilePath 'C:\temp\DotNetFramework4.8\ndp48-x86-x64-allos-enu.exe' -ArgumentList '/quiet', '/norestart' -Wait}
	Remove-PSSession -Session $serverPSSession
}
catch {
    $PSCmdlet.ThrowTerminatingError($_)
}
Write-Verbose -Message "NSClient++ installed on [$newStageHostName]" -Verbose
#endregion NSClient++
#endregion Deploy

#region Cleanup
# Set current (now previous) Stage server to have "PROD PENDING" as its Status tag value
Write-Verbose -Message "Setting 'Status' tag to 'PROD PENDING' on previous Stage server" -Verbose
Write-Verbose -Message "Setting 'Name' tag to '$currentStageHostName *PROD PENDING*' on previous Stage server" -Verbose
$pendingProdTag = @(
    @{key = 'Name'; value = "$currentStageHostName *PROD PENDING*" }
    @{key = 'Status'; value = 'PROD PENDING' }
)
New-EC2Tag -Resource $currentStageServer.InstanceId -Region $region -Tag $pendingProdTag

# TODO: deleting the snapshot too quickly causes the build to fail
# Write-Verbose -Message "Removing snapshot [$($snapshot.SnapshotId)] from AWS" -Verbose
# Remove-EC2Snapshot -SnapshotId $snapshot.SnapshotId -Force
Write-Warning -Message "Please remove snapshot [$($snapshot.SnapshotId)] from AWS manually once new server is running."

#PSscriptRoot references the send-graphemail.ps1 script to send email via graph api 

."$Psscriptroot..\..\helpers\Send-GraphEmail.ps1"

#Mail Arguments for Send-GraphEmail.ps1 function
$mailArgs = @{
    To         = "$env:USERNAME@erieri.com"
    From       = "$env:USERNAME@erieri.com"
    Subject    = "Assessors Stage Server $newStageHostName Build Complete"
    Body       = "Stage server $newStageHostName has been built. Please allow a few minutes for it to finish configuration."
}
Send-GraphEmail @mailArgs
#endregion Cleanup