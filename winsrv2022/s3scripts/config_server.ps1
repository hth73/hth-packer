# ----------------------------------------------------------------------------------------------------
# Description: Microsoft PowerShell script to deploy Windows Server Settings
# Author: Helmut Thurnhofer
# Date: 23.02.2022
# ----------------------------------------------------------------------------------------------------
Clear-Host

Write-Host "---------------------------------------------------------------"
Write-Host "- Change Disk Label"
Write-Host "----------------------------------------------------------------"
cmd /c "label C: System"

# ----------------------------------------------------------------------------------------------------

Write-Host "---------------------------------------------------------------"
Write-Host "- Set Environment Variables and Regkeys"
Write-Host "----------------------------------------------------------------"
## Show hidden device driver
[Environment]::SetEnvironmentVariable("devmgr_show_nonpresent_devices", "1", "Machine")

## diable IPv6
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters' -Name 'DisabledComponents' -Value '0x000000ff' -Type DWord -Force | Out-Null

## disable Auto Reboot
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl' -Name 'AutoReboot' -Value '0x00000000' -Type DWord -Force | Out-Null

## IE Enhanced Security Configuration - disable Administrator
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}' -Name 'IsInstalled' -Value '0x00000000' -Type DWord -Force | Out-Null

# ----------------------------------------------------------------------------------------------------

Write-Host "---------------------------------------------------------------"
Write-Host "- Set Windows Explorer Settings"
Write-Host "----------------------------------------------------------------"
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowRecent' -Value '0x00000000' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowFrequent' -Value '0x00000000' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -Value '0x00000000' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'SuperHidden' -Value '0x00000001' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'WebView' -Value '0x00000000' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'DontPrettyPath' -Value '0x00000001' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'NoNetCrawling' -Value '0x00000001' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Value '0x00000001' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value '0x00000000' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -Value '0x00000001' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarSmallIcons' -Value '0x00000001' -Type DWord -Force | Out-Null
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarGlomLevel' -Value '0x00000001' -Type DWord -Force | Out-Null
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon'
Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'MinimizedStateTabletModeOff' -Value '0x00000000' -Type DWord -Force | Out-Null

New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons'
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu'
New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Value '0x00000000' -Type DWord -Force | Out-Null
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name '{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -Value '0x00000000' -Type DWord -Force | Out-Null

# ----------------------------------------------------------------------------------------------------

Write-Host "---------------------------------------------------------------"
Write-Host "- delete all folders in MyPC"
Write-Host "----------------------------------------------------------------"
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A} /f'
cmd /C 'reg delete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641} /f'
