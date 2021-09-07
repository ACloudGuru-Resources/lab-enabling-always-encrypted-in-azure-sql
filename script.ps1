# Set some defaults
$ErrorActionPreference = "Stop"
$LogFile = Join-Path -Path ($env:ProgramData) -ChildPath "Labsetup.log"

# Functions
function Write-Log {
    param (
        [string]$Value,
        [string]$Level = "Info",
        [string]$Path = $LogFile
    )
    Add-Content -Path $Path -Value "[$($Level)] - [$(Get-Date)] - $Value" -Force
}

# Disable Server Manager
try {
    Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\ServerManager' -Name 'DoNotOpenServerManagerAtLogon' -Value 1 -Force
    Write-Log -Value "Disabled Server Manager"
} catch {
    Write-Log -Value "Could not disable Server Manager" -Level "Error"
    Write-Log -Value $_ -Level "Error"
}
# Disable IE ESC
try {
    Set-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}' -Name 'IsInstalled' -Value 0
    Write-Log -Value "Disabled IE ESC"
} catch {
    Write-Log -Value "Could not disable IE ESC" -Level "Error"
    Write-Log -Value $_ -Level "Error"
}

 # Download SQL Server Management Studio
try {
    Invoke-WebRequest -Uri "https://aka.ms/ssmsfullsetup" -UseBasicParsing -OutFile "$($env:ProgramData)\SSMS-Setup-ENU.exe";
    Write-Log -Value "Downloaded SSMS "
}
catch {
    Write-Log -Value "Could not download SSMS" -Level "Error"
    Write-Log -Value $_ -Level "Error"
}

 # Install SQL Server Management Studio
try {
    Start-Process -FilePath "$($env:ProgramData)\SSMS-Setup-ENU.exe" -ArgumentList @('/install', '/quiet', '/norestart', 'DoNotInstallAzureDataStudio=1') -Wait;
    Write-Log -Value "Installed SQL Server Management Studio"
}
catch {
    Write-Log -Value "Could not SQL Server Management Studio" -Level "Error"
    Write-Log -Value $_ -Level "Error"
}

 # Create SSMS Desktop Shortcut
try {
    Copy-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft SQL Server Tools 18\Microsoft SQL Server Management Studio 18.lnk" -Destination "C:\Users\Public\Desktop\Microsoft SQL Server Management Studio.lnk" -Force
    Write-Log -Value "Created SSSMS Desktop Shortcut"
}
catch {
    Write-Log -Value "Could not create SSMS Desktop Shortcut" -Level "Error"
    Write-Log -Value $_ -Level "Error"
}