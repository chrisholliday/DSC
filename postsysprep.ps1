# postsysprep.ps1
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
#install Defender
#install MMA
Set-DscLocalConfigurationManager -Path 'C:\Deploy\DscMetaConfigs' -ComputerName localhost
Start-sleep 30
While ((Get-DscLocalConfigurationManager).lcmstate -ne "Idle"){
Start-Sleep 5    
}
#start-sleep -Seconds 120
Unregister-ScheduledTask -TaskName 'PostSysprep' -Confirm:$false
Unregister-ScheduledTask -TaskName 'UserMessage' -Confirm:$false

Write-Output "Setting task for another reboot"
$actionSystem = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -NonInteractive -file c:\deploy\finalreboot.ps1 -executionpolicy bypass'
$triggerSystem = New-ScheduledTaskTrigger -AtStartup
$pricipalSystem = New-ScheduledTaskPrincipal -UserId "System" -LogonType ServiceAccount
Register-ScheduledTask -Action $actionSystem -Trigger $triggerSystem -Principal $pricipalSystem -TaskName "FinalReboot" -Description "Final Reboot"

Restart-Computer -Force