# PowerShell Desired State Configuration files (Windows Server 2019 & Azure Automation)

I'm using these scripts in conjunction with Azure Automation State Configuration (DSC) to help manage and maintain the configuration on my Windows Server 2019 devices. Note: it is not necessary that the Windows Computers be in Azure. I have managed devices on-prem and in AWS just fine with these tools. Your only real concern will be making sure that the computer has a path to the internet (often a proxy configuration).

## Warning:
Newly created Azure Automation Accounts tend to have VERY outdated modules. You WILL encounter problems with configuraiton processing if you do not upgrade these modules to something close to current. In particular you want to pay attention to: **AuditPolicyDsc** and **AuditPolicyDsc**.

## Steps for Success 
Step One - Create an Azure Automation Account

Step Two - Update your Modules. Seriously, don't overlook this.

Step Three - Upload your DSC configuration .PS1 file as a Configuration. Note: The filename must match the configuration name. Don't use spaces or dashes in the name.

Step Four - Compile the configuration.

Step Five - From a windows computer with PowerShell DSC, and the files available update the $PARAMS section of the AADSC_Meta.ps1 file to reflect your enviornment.

Step Six - Execute the updated AADSC_Meta.ps1 file to create your "localhost.MOF" file.

Step Seven - Stage the file somewhere, I typically choose "C:\\DscMetaConfigs" 

Step Six - Run Command "Set-DscLocalConfigurationManager -Path 'C:\DscMetaConfigs' -ComputerName localhost".  

Step Seven - Check your Automation Account, it should almost instantly be detected and start evaluating compliance.  

Step Eight - Evauate the compliance  

Step Nine - Tell everyone how easy it is to mananage and maintain DSC configuration in Azure Automation Accounts. 