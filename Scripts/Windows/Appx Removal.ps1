$RemoveAppx = "Microsoft.BingWeather_4.46.31121.0_x64__8wekyb3d8bbwe","Microsoft.Microsoft3DViewer_7.2105.4012.0_x64__8wekyb3d8bbwe", "Microsoft.MSPaint_6.2105.4017.0_x64__8wekyb3d8bbwe"

foreach ($Item in $RemoveAppx) {
    Remove-AppxPackage $Item -Confirm
}


