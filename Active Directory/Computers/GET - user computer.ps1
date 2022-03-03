$Username = "daniel.alvarez"

Get-ADComputer -Filter * -Properties * | Where-Object description -Match $Username | foreach name