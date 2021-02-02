Unregister-ScheduledTask -TaskName "Register Computer" -Confirm:$false
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-DscLocalConfigurationManager -Path 'C:\Staging\DscMetaConfig' -ComputerName localhost
start-sleep -Seconds 600
Restart-Computer