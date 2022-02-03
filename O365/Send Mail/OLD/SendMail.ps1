$mailArgs = @{
    SmtpServer = 'd188133a.ess.barracudanetworks.com'
    To         = daniel.alvarez@erieri.com
    From       = test.dalvarez@erieri.com
    Credential = $Credential
    UseSsl     = $true
    Port       = 587
    Subject    = "Assessors Stage Server $newStageHostName Build Complete"
    Body       = "Stage server $newStageHostName has been built. Please allow a few minutes for it to finish configuration."
    BodyAsHtml = $true
    Priority   = 'High'
}
Send-MailMessage @mailArgs
#endregion Cleanup

