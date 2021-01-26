# DSC
PowerShell Desired State Configuration sample scripts

I'm using these scripts in conjunction with Azure Automation State Configuration (DSC).

Notes:
If you are using Azure Automation please ensure you update the modules: AuditPolicyDsc and AuditPolicyDsc.  By default these are VERY out of date and will cause errors on DSC module processing.

Windows DSC
Step One - Create an Azure Automation Account
Step Two - Update your Modules. Seriously, don't overlook this.
Step Three - Upload your DSC configuration .PS1 file as a Configuration. Note: The filename must match the configuration name. Don't use spaces or dashes in the name.
Step Four - Compile the configuration
Step Five - Place the folder DscMetaConfigs (with the mof file) on root of c (c:\).
Step Six - Run Command "Set-DscLocalConfigurationManager -Path 'C:\DscMetaConfigs' -ComputerName localhost"
Step Seven - Check your Automation Account, it should almost instantly be detected and start evaluating compliance.
Step Eight - ???
Step Nine - Profit
