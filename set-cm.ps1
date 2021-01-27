Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
Set-DscLocalConfigurationManager -Path 'C:\DscMetaConfigs' -ComputerName localhost
start-sleep -Seconds 120
Restart-Computer