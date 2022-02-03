$appname = @(
"*Microsoft.BingWeather*"
"*Microsoft.MSPaint*"
"*Microsoft.Microsoft3DViewer*"
"*Microsoft.MixedReality.Portal*"
"*Microsoft.Paint3D*"
"*Microsoft.XboxGameCallableUI*"
"*Microsoft.ZuneMusic*"                        
"*Microsoft.ZuneVideo*"
"*Print3D*"
"*Solitaire*"
"*SkypeApp*"
"*Microsoft.MixedReality.Portal*"
"*Microsoft.People*"
"*Microsoft.windowscommunicationsapps*"
"*Microsoft.cbspreview*"
"*DellInc.*"
"*Microsoft.WindowsSoundRecorder*"
"*Microsoft.YourPhone*"
)

ForEach($app in $appname){
Get-AppxPackage -AllUsers -Name $app -PackageTypeFilter Bundle | Remove-AppxPackage
}