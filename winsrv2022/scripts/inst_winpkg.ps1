# ----------------------------------------------------------------------------------------------------
# Description: Microsoft PowerShell script to install software and server roles
# Author: Helmut Thurnhofer
# Date: 23.02.2022
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
  
  ## Update Path Environment in Current Powershell Session
  function Update-EnvPath {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
                ";" +
                [System.Environment]::GetEnvironmentVariable("Path","User")
  }

  Write-Host "--------------------------------------------------"
  Write-Host "- Installing AWS-CLI"
  Write-Host "--------------------------------------------------"
  $awscli = (Start-Process -FilePath msiexec.exe -ArgumentList "/i","C:\tools\AWSCLIV2.msi","/qn","/norestart" -NoNewWindow -Wait -PassThru)
  Update-EnvPath
  if ($awscli.ExitCode -ne 0) {
    Write-Error "Error installing AWS-CLI"
    exit 1
  }
}
catch {
  Write-Error $_.Exception
  exit 1
}

## Downloading all Packages from S3 Bucket with iam_instance_profile
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
