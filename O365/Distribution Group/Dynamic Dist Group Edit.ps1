Connect-ExchangeOnline -UserPrincipalName dalvarez@sureco.com -ShowProgress $true


#Dynamic Dist. Group
Set-DynamicDistributionGroup -Identity "All Staff" -AcceptMessagesOnlyFromSendersOrMembers @{add='GroupEmailAddress'}