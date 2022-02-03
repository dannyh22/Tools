$RemoveAppx = "CommunicationsApps","OfficeHub","People","Skype","Solitaire","Xbox","ZuneMusic","ZuneVideo", "Dell"

foreach ($Item in $RemoveAppx) {
    Remove-AppxOnline -Name $Item
}