$removeappx = "Dell","CommunicationApps","OfficeHub","People","Skype","Solitaire","Xbox","Zune"

foreach ($item in $removeappx) {

    Remove-AppxOnline -Name $item
        
}