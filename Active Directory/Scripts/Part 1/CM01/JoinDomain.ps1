<#
# Join Domain, 2018/3/28 Niall Brady, https://www.windows-noob.com
#
# This script:            Joins a computer to the domain 
# Before running:         Configure the variables below (lines 16-18)
# Usage:                  Run this script as Administrator on a WorkGroup joined server
#>

  If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
        [Security.Principal.WindowsBuiltInRole] “Administrator”))

    {
        Write-Warning “You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”
        Break
    }
$domain = "windowsnoob"
$password = "P@ssw0rd" | ConvertTo-SecureString -asPlainText -Force
$joindomainuser = "Administrator"

$username = "$domain\$joindomainuser" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)

try{
     Add-Computer -DomainName $domain -Credential $credential -ErrorAction Stop
     Restart-Computer
}

catch{
    Write-Host "Oops, we couldn't join the Domain, here is the error:" -fore red
    $_   # error output
}

finally{
    Write-Host 'Finishing script...' -fore green
}

