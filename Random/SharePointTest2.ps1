$Token = ConvertTo-SecureString 'eyJ0eXAiOiJKV1QiLCJub25jZSI6IjBzVGFGRGRKYUEyd3BHZmJNTjdxUURZY2FyRmJiYUNCVHhOVnM2TFFoNkEiLCJhbGciOiJSUzI1NiIsIng1dCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyIsImtpZCI6Im5PbzNaRHJPRFhFSzFqS1doWHNsSFJfS1hFZyJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9mODJiZDU2OS0xNWJmLTRlZDctODgyNi1mMWJiZjNiM2ZiNTMvIiwiaWF0IjoxNjE2MDI1NjUzLCJuYmYiOjE2MTYwMjU2NTMsImV4cCI6MTYxNjAyOTU1MywiYWNjdCI6MCwiYWNyIjoiMSIsImFjcnMiOlsidXJuOnVzZXI6cmVnaXN0ZXJzZWN1cml0eWluZm8iLCJ1cm46bWljcm9zb2Z0OnJlcTEiLCJ1cm46bWljcm9zb2Z0OnJlcTIiLCJ1cm46bWljcm9zb2Z0OnJlcTMiLCJjMSIsImMyIiwiYzMiLCJjNCIsImM1IiwiYzYiLCJjNyIsImM4IiwiYzkiLCJjMTAiLCJjMTEiLCJjMTIiLCJjMTMiLCJjMTQiLCJjMTUiLCJjMTYiLCJjMTciLCJjMTgiLCJjMTkiLCJjMjAiLCJjMjEiLCJjMjIiLCJjMjMiLCJjMjQiLCJjMjUiXSwiYWlvIjoiQVVRQXUvOFRBQUFBLzZYbVU1eUp5ejVMcXJ5RkRha1RENSt1elcvNVpFb3ZlWE8xa3ZjTU1NR1RQeHkvUGpEckNidEEwSzZhMGtxSm5rd0RTamNUZXdRZTdjUVZpcVJqdWc9PSIsImFtciI6WyJwd2QiLCJtZmEiXSwiYXBwX2Rpc3BsYXluYW1lIjoiR3JhcGggZXhwbG9yZXIgKG9mZmljaWFsIHNpdGUpIiwiYXBwaWQiOiJkZThiYzhiNS1kOWY5LTQ4YjEtYThhZC1iNzQ4ZGE3MjUwNjQiLCJhcHBpZGFjciI6IjAiLCJmYW1pbHlfbmFtZSI6IkFsdmFyZXoiLCJnaXZlbl9uYW1lIjoiRGFuaWVsIiwiaWR0eXAiOiJ1c2VyIiwiaXBhZGRyIjoiNDcuMTQ3LjAuMTAwIiwibmFtZSI6IkRhbmllbCBBbHZhcmV6Iiwib2lkIjoiM2ZmNzkzYWYtODVkMC00ZjM1LWE1NmEtNTQwOTUyODNlMmUxIiwib25wcmVtX3NpZCI6IlMtMS01LTIxLTI4MTY0NDIyNTEtMzk5MzQyOTczMi0zMTI2ODgwNzg2LTE2NDUiLCJwbGF0ZiI6IjUiLCJwdWlkIjoiMTAwMzIwMDA5MUMwOEQ3MSIsInJoIjoiMC5BUmdBYWRVci1MOFYxMDZJSnZHNzg3UDdVN1hJaTk3NTJiRklxSzIzU05weVVHUVlBUG8uIiwic2NwIjoib3BlbmlkIHByb2ZpbGUgU2l0ZXMuUmVhZC5BbGwgU2l0ZXMuUmVhZFdyaXRlLkFsbCBVc2VyLlJlYWQgZW1haWwiLCJzdWIiOiJXanRJdVplR0tZSU9OdlRSVTZKSEQxUURlZ0tCN0k4RWVNTFhfZXpXNGZzIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6Ik5BIiwidGlkIjoiZjgyYmQ1NjktMTViZi00ZWQ3LTg4MjYtZjFiYmYzYjNmYjUzIiwidW5pcXVlX25hbWUiOiJkYWx2YXJlekBzdXJlY28uY29tIiwidXBuIjoiZGFsdmFyZXpAc3VyZWNvLmNvbSIsInV0aSI6IjdodFdwOUdnS0VHSktBelZUOGJXQUEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbIjk1ZTc5MTA5LTk1YzAtNGQ4ZS1hZWUzLWQwMWFjY2YyZDQ3YiIsIjlmMDYyMDRkLTczYzEtNGQ0Yy04ODBhLTZlZGI5MDYwNmZkOCIsIjYyZTkwMzk0LTY5ZjUtNDIzNy05MTkwLTAxMjE3NzE0NWUxMCIsIjY5MDkxMjQ2LTIwZTgtNGE1Ni1hYTRkLTA2NjA3NWIyYTdhOCIsIjI5MjMyY2RmLTkzMjMtNDJmZC1hZGUyLTFkMDk3YWYzZTRkZSIsIjdiZTQ0YzhhLWFkYWYtNGUyYS04NGQ2LWFiMjY0OWUwOGExMyIsImZjZjkxMDk4LTAzZTMtNDFhOS1iNWJhLTZmMGVjODE4OGExMiIsIjJiNzQ1YmRmLTA4MDMtNGQ4MC1hYTY1LTgyMmM0NDkzZGFhYyIsImM0ZTM5YmQ5LTExMDAtNDZkMy04YzY1LWZiMTYwZGEwMDcxZiIsIjNhMmM2MmRiLTUzMTgtNDIwZC04ZDc0LTIzYWZmZWU1ZDlkNSIsIjc2OThhNzcyLTc4N2ItNGFjOC05MDFmLTYwZDZiMDhhZmZkMiIsImU4NjExYWI4LWMxODktNDZlOC05NGUxLTYwMjEzYWIxZjgxNCIsIjE1OGMwNDdhLWM5MDctNDU1Ni1iN2VmLTQ0NjU1MWE2YjVmNyIsIjExNjQ4NTk3LTkyNmMtNGNmMy05YzM2LWJjZWJiMGJhOGRjYyIsImYyOGExZjUwLWY2ZTctNDU3MS04MThiLTZhMTJmMmFmNmI2YyIsImY3MDkzOGEwLWZjMTAtNDE3Ny05ZTkwLTIxNzhmODc2NTczNyIsImE5ZWE4OTk2LTEyMmYtNGM3NC05NTIwLThlZGNkMTkyODI2YyIsIjc5MGMxZmI5LTdmN2QtNGY4OC04NmExLWVmMWY5NWMwNWMxYiIsImZlOTMwYmU3LTVlNjItNDdkYi05MWFmLTk4YzNhNDlhMzhiMSIsIjliODk1ZDkyLTJjZDMtNDRjNy05ZDAyLWE2YWMyZDVlYTVjMyIsImYwMjNmZDgxLWE2MzctNGI1Ni05NWZkLTc5MWFjMDIyNjAzMyIsImZkZDdhNzUxLWI2MGItNDQ0YS05ODRjLTAyNjUyZmU4ZmExYyIsIjRkNmFjMTRmLTM0NTMtNDFkMC1iZWY5LWEzZTBjNTY5NzczYSIsIjcyOTgyN2UzLTljMTQtNDlmNy1iYjFiLTk2MDhmMTU2YmJiOCIsImJhZjM3YjNhLTYxMGUtNDVkYS05ZTYyLWQ5ZDFlNWU4OTE0YiIsIjE5NGFlNGNiLWIxMjYtNDBiMi1iZDViLTYwOTFiMzgwOTc3ZCIsImI3OWZiZjRkLTNlZjktNDY4OS04MTQzLTc2YjE5NGU4NTUwOSJdLCJ4bXNfc3QiOnsic3ViIjoiZ3VuUWVFblVyejBhdURKTllhcGFobUt6Sm9PMnhwN3dVRUU0YXJiS00zWSJ9LCJ4bXNfdGNkdCI6MTQ1ODkyOTUzNH0.TkywqNFOZlYqX3Xvq9j_muW1YJXT4mK-2Dyekpzfy29hnwhfAmlIIUyAZskJKmG8_0xbAwStzeUAoJRZoQe5h_n4JVUa_c8VlOj2kv0qAp7wiu2QfP9SCsUeUIuQGLkiEhvyKoIoWrRHJB9PJqBhW1gtFK07DoNxLkOgvtMAsGpqsFFf3UvtRed3UF-lUj7C9bIGVuYvTJGLRFX_5pLdjJNpfn0IOmqbt7TEDOyLCj1PIYIgrKd2lNZWgOgsKwpFYkSHe1kEHU51Grv0kuwVpjQeqzzy-yQP8wDRfBia4eo55iKdKq-p9sTq_zacd5xbCAFh06VbOrAOpgFFXqRc6g' -AsPlainText -Force

$URI = "https://graph.microsoft.com/v1.0/sites/8b658dd0-5ca3-48bb-9cad-b7dc3cf840fe/lists/9a414f6d-da25-4172-a9c5-89f17d436389/items?expand=fields(select=FirstName,LastName,JobTitle,Department,Manager,Location,Status)"

$Method = "GET"

$headers = @{
    "content-type" = "application/json"
}

Invoke-RestMethod -Method $Method -URI $URI -Token $AccessToken -Headers $headers