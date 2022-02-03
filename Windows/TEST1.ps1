$appname = @(
"*BingWeather*"
"*MSPaint*"
"*Pain3D*"
"*Xbox*"
)

ForEach($app in $appname){
Get-AppxPackage -AllUsers -Name $app -PackageTypeFilter Bundle | Remove-AppxPackage -ErrorAction SilentlyContinue
}