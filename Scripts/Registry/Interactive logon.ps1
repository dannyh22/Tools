$path = "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

Set-Location -Path $path

New-ItemProperty $path -PropertyType dword -Name "Interactive TimeoutSecs" -Value 120