$name = "Daniel Alvarez"

Get-aduser -filter * -prop * | ? Name -match “$name” | select-object PasswordExpired