# Staging script

# Check for Required components
if (Get-ChildItem 'C:\Program Files\WindowsPowerShell\Modules\AuditPolicyDsc\'){
    If (Get-ChildItem 'C:\Program Files\WindowsPowerShell\Modules\NetworkingDsc\'){
        if (Get-ChildItem 'C:\Program Files\WindowsPowerShell\Modules\SecurityPolicyDsc\'){
            Write-Output "All Powershell Module Dependencies are met"
        }else {
            Write-Output "Missing NetworkingDsc"
            exit
        }
    }else {
        Write-Output "Missing NetworkingDsc"
        exit 
    }
}else {
    Write-Output "Missing AuditPolicyDsc"
    exit
}

# Apply Base Configuration
If (Get-ChildItem 'C:\deploy\FRS_Win19_GI_v1\'){
    Write-Output "Setting Local Gold Image Configuration"
    Start-DscConfiguration -Path C:\deploy\FRS_Win19_GI_v1\ -wait   
}else {
    Write-Output "Missing Local Configuration File"
    exit
}

# Remove Configuration Document (allows later check in with Automation Account)
Remove-DscConfigurationDocument -Stage Current, Pending, Previous

# Create a scheduled task to run after Sysprep
If (Get-ChildItem 'C:\deploy\postsysprep.ps1'){
    Write-Output "Setting Post Sysprep Scheduled Task"
    $actionSystem = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-NoProfile -NonInteractive -file c:\deploy\postsysprep.ps1 -executionpolicy bypass'
    $triggerSystem = New-ScheduledTaskTrigger -AtStartup 
    $pricipalSystem = New-ScheduledTaskPrincipal -UserId "System" -LogonType ServiceAccount
    Register-ScheduledTask -Action $actionSystem -Trigger $triggerSystem -Principal $pricipalSystem -TaskName "PostSysprep" -Description "FRS - Register with Management Tools"
}else {
    Write-Output "Missing PostSysPrep.ps1 file"
    exit
}

# Create a scheduled task to run after Sysprep if a user logs in, before the reboot
Write-Output "Setting Post Sysprep User Message Task"
$actionUser = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-noprofile -nologo -noexit -command write-host "The system is applying final configuration updates and will reboot within 2 minutes"'
$triggerUser = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -Action $actionUser -Trigger $triggerUser -TaskName "UserMessage" -Description "UserMessage"
C:\Windows\System32\Sysprep\sysprep.exe /unattend:c:\deploy\unattend.xml /generalize /shutdown /oobe