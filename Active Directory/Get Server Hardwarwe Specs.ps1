$ArrComputers =
(
"SNA-DEV-BUILD02",
"SNA-DEV-BUILD03",
"SNA-IIS-E01",
"SNA-IIS-SE01",
"SNALOGGING",
"SNA-PWSHAUTO",
"SNAPATCH01",
"SNAPVDC2",
"SNAPVTFS02",
"SNA-HVDC3",
"SNA-IMGDEPLOY",
"SNA-NETWRIX01", 
"SNA-TRIT02",
"SNA-UNIFICONTROL",
"SNADV2W3",     
"SNAPITUTIL1",
"SNAPVFILE1"
)
#Specify the list of PC names in the line above. "." means local system

Clear-Host
foreach ($server in $ArrComputers) 
{
    $computerHDD = (gwmi win32_logicaldisk)[0]|select model, @{Name="GB";Expression={$_.size/1GB}}
    $computerMemory = (Get-CimInstance Win32_PhysicalMemory -ComputerName $server | Measure-Object -Property capacity -Sum).sum /1gb
        write-host "System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
        "-------------------------------------------------------"
        "$server HDD = $computerHDD" + "GB"
        "$server RAM = $computerMemory" + "GB"
            
}