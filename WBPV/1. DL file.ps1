# Define the URL of the file to be downloaded
$url = "https://example.com/file.zip"  # Replace with your file URL

# Define the path to save the file in the %temp% folder
$tempPath = [System.IO.Path]::Combine($env:TEMP, "downloaded_file.zip")  # Replace "downloaded_file.zip" with your desired filename

# Use Invoke-WebRequest to download the file
Invoke-WebRequest -Uri $url -OutFile $tempPath

# Output the location of the downloaded file
Write-Host "File downloaded to: $tempPath"