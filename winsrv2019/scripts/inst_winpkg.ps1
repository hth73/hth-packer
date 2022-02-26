# ----------------------------------------------------------------------------------------------------
# Description: Microsoft PowerShell script to install software and server roles
# Author: Helmut Thurnhofer
# Date: 11.11.2021
# ----------------------------------------------------------------------------------------------------

## Create C:\tmp and C:\tools Folder
##
try {
  Write-Host "--------------------------------------------------"
  Write-Host "- Create C:\tmp and C:\tools Folder"
  Write-Host "--------------------------------------------------"
  if (!(Test-Path -Path "C:\tmp")) {New-Item -Path C:\ -Name tmp -ItemType Directory}
  if (!(Test-Path -Path "C:\tools")) {New-Item -Path C:\ -Name tools -ItemType Directory}
}
catch {
  Write-Error $_.Exception
  exit 1
}

## Downloading and installing AWS-CLI
##
try {
  Write-Host "--------------------------------------------------"
  Write-Host "- Downloading AWS-CLI"
  Write-Host "--------------------------------------------------"
  if (!(Test-Path -Path "C:\tools\AWSCLIV2.msi")) {Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile "C:\tools\AWSCLIV2.msi" -Verbose}
  function UpdateEnvPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
                ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
  }
  Write-Host "--------------------------------------------------"
  Write-Host "- Installing AWS-CLI"
  Write-Host "--------------------------------------------------"
  $awscli = (Start-Process -FilePath msiexec.exe -ArgumentList "/i","C:\tools\AWSCLIV2.msi","/qn","/norestart" -NoNewWindow -Wait -PassThru)
  UpdateEnvPath
  if ($awscli.ExitCode -ne 0) {
    Write-Error "Error installing AWS-CLI"
    exit 1
  }
}
catch {
  Write-Error $_.Exception
  exit 1
}

## Downloading all Packages from S3 Bucket
##
try {
  Write-Host "--------------------------------------------------"
  Write-Host "- Downloading all Packages from S3 Bucket"
  Write-Host "--------------------------------------------------"
  function Get-TimeStamp {  
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) 
  }

  aws sts get-caller-identity
  Write-output "$(Get-TimeStamp) Start Download"
  aws s3 cp --recursive s3://win-srv-packer-softwaredepot C:\tools
  Write-output "$(Get-TimeStamp) Finished Download"
  Get-ChildItem -Path C:\tools -Recurse
}
catch {
  Write-Error $_.Exception
  exit 1
}

## Installing Microsoft Edge Browser 96.0.1054
##
try {
  Write-Host "---------------------------------------------------------------"
  Write-Host "- Installing Microsoft Edge Browser 96.0.1054"
  Write-Host "----------------------------------------------------------------"
  $msedge = (Start-Process -FilePath msiexec.exe -ArgumentList "/i","C:\tools\winpkg\MicrosoftEdgeEnterprise_96.0.1054.msi","/qn","/norestart" -NoNewWindow -Wait -PassThru)
  if ($msedge.ExitCode -ne 0) {
    Write-Error "Error installing Microsoft Edge Browser 96.0.1054"
    exit 1
  }
}
catch {
  Write-Error $_.Exception
  exit 1
}

## Installing Microsoft .NET Core 3.1.21 Windows Server Hosting
##
try {
  Write-Host "--------------------------------------------------"
  Write-Host "- Installing Windows Server Hosting 3.1.21"
  Write-Host "--------------------------------------------------"
  $dotnet = (Start-Process "C:\tools\winpkg\dotnetHosting_3.1.21.exe" -ArgumentList "/install","/quiet","/norestart" -NoNewWindow -Wait -PassThru)
  if ($dotnet.ExitCode -ne 0) {
    Write-Error "Error installing Windows Server Hosting 3.1.21"
    exit 1
  }
}
catch {
  Write-Error $_.Exception
  exit 1
}

## Installing IIS Webserver Role
##
try {
Write-Host "--------------------------------------------------"
Write-Host "- Installing IIS Webserver Role"
Write-Host "--------------------------------------------------"
$IIS_Features = @(
  "IIS-DefaultDocument",
  "IIS-HttpErrors",
  "IIS-StaticContent",
  "IIS-RequestFiltering",
  "IIS-CertProvider",
  "IIS-IPSecurity",
  "IIS-URLAuthorization",
  "IIS-ApplicationInit",
  "IIS-WindowsAuthentication",
  "IIS-NetFxExtensibility45",
  "IIS-ASPNET45",
  "IIS-ISAPIExtensions",
  "IIS-ISAPIFilter",
  "IIS-WebSockets",
  "IIS-ManagementConsole",
  "IIS-ManagementScriptingTools",
  "ClientForNFS-Infrastructure"
)

  Function Confirm-IISPrerequisites {    
  ## Verify that all required IIS components have been installed
  Write-Host "Verify that all required IIS components have been installed"
    foreach ($Feature in $IIS_Features) {
      if((Get-WindowsOptionalFeature -Online -FeatureName $Feature).State -eq "Disabled"){
        Write-Host "-- $($Feature) Feature is missing! --" 
        Write-Host "-- $($Feature) is installing now. --"
          Enable-WindowsOptionalFeature -Online -FeatureName $Feature -All -NoRestart
      }
    }
    Write-Host "All required IIS components have been installed"
  }
  Confirm-IISPrerequisites
}
catch {
  Write-Error $_.Exception
  exit 1
}

## Installing Microsoft Web Platform Installer 5.1
##
try {
  Write-Host "---------------------------------------------------"
  Write-Host "- Installing Microsoft Web Platform Installer 5.1 "
  Write-Host "---------------------------------------------------"
  $webpla = (Start-Process -FilePath msiexec.exe -ArgumentList "/i","C:\tools\winpkg\WebPlatformInstaller_5.1.msi","/qn","/norestart" -NoNewWindow -Wait -PassThru)
  if ($webpla.ExitCode -ne 0) {
    Write-Error "Error installing Microsoft Web Platform Installer 5.1"
    exit 1
  }

  ## Installing URL Rewrite 2.1
  ##
  Write-Host "--------------------------------------------------"
  Write-Host "- Installing URL Rewrite 2.1"
  Write-Host "--------------------------------------------------"
  $rewrite = (Start-Process -FilePath "C:\Program Files\Microsoft\Web Platform Installer\WebpiCmd.exe" -ArgumentList "/Install","/Products:UrlRewrite2","/AcceptEULA" -NoNewWindow -Wait -PassThru)
  if ($rewrite.ExitCode -ne 0) {
    Write-Error "Error installing URL Rewrite 2.1"
    exit 1
  }
}
catch {
  Write-Error $_.Exception
  exit 1
}
