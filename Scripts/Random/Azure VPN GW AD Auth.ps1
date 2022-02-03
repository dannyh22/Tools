Install-Module AzureRM -Force

Connect-AzureRMAccount

#Enable Azure AD Auth on VPN Gateway# 
$gw = Get-AzVirtualNetworkGateway -Name SureCo-WVD -ResourceGroupName SureCo-wvd-rg
Set-AzVirtualNetworkGateway -VirtualNetworkGateway $gw -VpnClientRootCertificates @()
Set-AzVirtualNetworkGateway -VirtualNetworkGateway $gw -AadTenantUri "https://login.microsoftonline.com/f82bd569-15bf-4ed7-8826-f1bbf3b3fb53/" -AadAudienceId "41b23e61-6c1e-4545-b367-cd054e0ed4b4" -AadIssuerUri "https://sts.windows.net/f82bd569-15bf-4ed7-8826-f1bbf3b3fb53/" -VpnClientAddressPool 172.16.20.0/24 -VpnClientProtocol OpenVPN

#Download Profile#
$profile = New-AzVpnClientConfiguration -Name sureco-wvd -ResourceGroupName sureco-wvd-rg -AuthenticationMethod "EapTls"
$PROFILE.VpnProfileSASUrl

