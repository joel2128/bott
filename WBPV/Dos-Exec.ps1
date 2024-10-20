# Define the path to the application and the output file
$appPath = "$env:TEMP\example.exe"
$outputFilePath = "$env:TEMP\data.txt"

# Start the application
$process = Start-Process -FilePath $appPath -PassThru

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
Stop-Process -Id $process.Id -Force

# Cleanup any lingering processes
Get-Process | Where-Object { $_.Path -like "$env:TEMP\example.exe" } | Stop-Process -Force

# Inform the user that the script is complete
Write-Host "Process completed and all instances closed."