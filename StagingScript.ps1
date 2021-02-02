# Staging Script
Write-Output "Installing NuGet"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Write-Output "Installing NetworkingDSC module"
Install-Module -Name "NetworkingDSC" -Force -Repository PSGallery

Write-Output "Installing AuditPolicyDSC module"
Install-Module -Name AuditPolicyDsc -Force -Repository PSGallery

Write-Output "Installing SecurityPolicyDsc module"
Install-Module -Name SecurityPolicyDsc -Force -Repository PSGallery

# Write-Output "Installing xPSDesiredStateConfiguration module"
# Install-Module -Name xPSDesiredStateConfiguration -Force -Repository PSGallery

Write-Output "Applying Local Configuration"
Start-DscConfiguration -Path C:\Staging\cis_local\ -ComputerName localhost
Get-Job | Wait-Job

Write-Output "Staging AutoConfig for first boot"
# $Action = New-ScheduledTaskAction -Execute powershell.exe -Argument '-NoProfile -WindowStyle Hidden c:\staging\autoexec.ps1'
$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument 'c:\staging\autoexec.ps1'
$Trigger = New-ScheduledTaskTrigger -AtStartup
$Settings= New-ScheduledTaskSettingsSet -StartWhenAvailable
$Principal = New-ScheduledTaskPrincipal -UserId "System" -LogonType ServiceAccount -RunLevel 'Highest'

Register-ScheduledTask -TaskName "Register Computer" -Action $Action -Trigger $Trigger -Settings $Settings -Principal $Principal

Write-Output "running Sysprep"
Set-Location $env:windir\system32\sysprep
.\sysprep.exe /generalize /shutdown /oobe