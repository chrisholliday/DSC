Write-Host "Please wait while we apply configuration settings and reboot"
Unregister-ScheduledTask -TaskName "Restart Computer" -Confirm:$false
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-DscLocalConfigurationManager -Path 'C:\Staging\DscMetaConfig' -ComputerName localhost
start-sleep -Seconds 120
Restart-Computer