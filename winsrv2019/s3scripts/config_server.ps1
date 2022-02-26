# ----------------------------------------------------------------------------------------------------
# Description: Microsoft PowerShell script to deploy UIPath Orchestrator Server
# Author: Helmut Thurnhofer @jambit GmbH
# Date: 23.11.2021
# Comment:
# ----------------------------------------------------------------------------------------------------
Clear-Host


## Powershell SqlServer Modul installieren
##
Function Install-ScriptModule {
  [cmdletbinding()]
  param(
    [Parameter(Mandatory)]
    [ValidateSet('SqlServer','AWSPowerShell')]
    [string]$Name
  )

  $Trusted = Get-PSRepository -Name PSGallery 2>$null
  $Trusted = $Trusted.InstallationPolicy 2>$null

  If ($Trusted -ne "Trusted") {
    Write-Host "Microsoft PSGallery is registered as a trusted repository...." -ForegroundColor Yellow
    Unregister-PSRepository PSGallery 2>$null;
    Register-PSRepository -Default;
    Set-PSRepository -Name PSGallery -Installation Trusted -Verbose:$false
  }
 
  $CheckNuGet = Get-PackageProvider
  $CheckNuGet = $CheckNuGet.Name.Contains("NuGet")

  If($CheckNuGet -eq $false){
    Write-Host "Installing NuGet PackageProvider..." -ForegroundColor Green
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
  }

  If ($Null -eq (Get-Module -ListAvailable -Name $Name)) {
    Write-Warning "Powershell module $Name not found..."
    Write-Host "$Name Powershell module will be installed..." -ForegroundColor Green
    Install-Module -Name $Name -Scope AllUsers -Verbose:$false -Confirm:$false -Force
    Write-Host "$Name Powershell Module will be loaded..." -ForegroundColor Green
    Import-Module $Name -ErrorAction Stop -Verbose:$false
  }
  Else {
    Write-Host "$Name Powershell module has been installed and loaded!" -ForegroundColor Green
  }
}
Install-ScriptModule -Name SqlServer
Install-ScriptModule -Name AWSPowerShell


## IIS Configuration and Registry Settings
##
Write-Host "--------------------------------------------------"
Write-Host "- IIS Configuration and Registry Settings"
Write-Host "--------------------------------------------------"
Start-Process -FilePath 'C:\tools\winconfig\winconfig.cmd' -Wait -PassThru


## Set Microsoft Edge Browser as Default Browser
##
Write-Host "--------------------------------------------------"
Write-Host "- Set Microsoft Edge as Default Browser"
Write-Host "--------------------------------------------------"
$Path = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice -Name ProgId).ProgId
$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
$Name = "DefaultAssociationsConfiguration"
$Value = 'C:\tools\winconfig\defaultapplication.xml'
$Result = "IE.HTTP"
if ($Path -eq $Result) {
  New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType String -Force
  Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice' -Name ProgId -Value 'MSEdgeHTM'
  Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice' -Name ProgId -Value 'MSEdgeHTM'
}
else {
  Write-Host "Cannot set Microsoft Edge as Default Browser"
}

## Repair Microsoft .NET Core 3.1.21 Windows Server Hosting
## Software must be repaired after sysprep/ami creation!
try {
  Write-Host "--------------------------------------------------"
  Write-Host "- Repair Windows Server Hosting 3.1.21"
  Write-Host "--------------------------------------------------"
  $dotnet = (Start-Process "C:\tools\winpkg\dotnetHosting_3.1.21.exe" -ArgumentList "/repair","/quiet","/norestart" -NoNewWindow -Wait -PassThru)
  if ($dotnet.ExitCode -ne 0) {
    Write-Error "Error repair Windows Server Hosting 3.1.21"
    exit 1
  }
}
catch {
  Write-Error $_.Exception
  exit 1
}
