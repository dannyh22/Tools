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

foreach($comp in $ArrComputers){
    
    $pingtest = Test-Connection -ComputerName $comp -Quiet -Count 1 -ErrorAction SilentlyContinue
    if($pingtest){
         Write-Host($comp + " is online")
     }
     else{
        Write-Host($comp + " is not reachable")
     }
     
}