Unregister-ScheduledTask -TaskName 'FinalReboot' -Confirm:$false
Start-sleep 10
While ((Get-DscLocalConfigurationManager).lcmstate -ne "Idle") {
    Start-Sleep 5    
}
Restart-Computer -Force