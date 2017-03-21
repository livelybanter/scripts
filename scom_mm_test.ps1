#--------Begin Sample Script----------------
#*****************************************************************************
#
# Name: OpsMgr 2012 Group Maintenance Mode 
#
# Description: Puts Groups into Maintenance Mode 
#
# Authors: Pete Zerger and Matthew Long  
#
# Parameters:
#
# -ScomServer: mandatory parameter containing mgmt server name (Netbios or FQDN)
# -GroupDisplayName: mandatory parameter containing display name of the target group
# -DurationInMin: mandatory parameter containing integer of desired duration in minutes
# -Reason: mandatory parameter containing reason. Acceptable values are UnplannedOther, 
#           PlannedHardwareMaintenance, UnplannedHardwareMaintenance,

#           PlannedHardwareInstallation, 
#           UnplannedHardwareInstallation, PlannedOperatingSystemReconfiguration, 
#           UnplannedOperatingSystemReconfiguration, PlannedApplicationMaintenance, 
#           ApplicationInstallation, ApplicationUnresponsive, ApplicationUnstable, 
#           SecurityIssue, LossOfNetworkConnectivity
# -Comment: optional parameter with free text description of your choice
#
#
#*****************************************************************************

Function GroupMaintMode 
#($ScomServer, $GroupDisplayName, $DurationInMin, $Reason, $Comment)
(
[Parameter(Mandatory=$true)][string]$ScomServer,
[Parameter(Mandatory=$true)][string]$GroupDisplayName,
[Parameter(Mandatory=$true)][Int32]$DurationInMin,
[Parameter(Mandatory=$true)][string]$Reason,
[Parameter(Mandatory=$false)][string]$Comment
){

Import-Module OperationsManager
New-SCOMManagementGroupConnection -ComputerName $ScomServer

ForEach ($Group in (Get-ScomGroup -DisplayName  $GroupDisplayName))
    {
   If ($group.InMaintenanceMode -eq $false)
         {
            $group.ScheduleMaintenanceMode([datetime]::Now.touniversaltime(), `
            ([datetime]::Now).addminutes($DurationInMin).touniversaltime(), `

             "$Reason", "$Comment" , "Recursive")
         }
    }

}

#Usage (calling the GroupMaintMode function)
GroupMaintMode -ScomServer "prd-scomms02" -GroupDisplayName "ConfigMgr Distribution Points Computer Group" `
-DurationInMin 10  -Reason "ApplicationInstallation" -Comment "Scheduled weekly maintenance"

#--------End Sample Script----------------

#Usage (calling the GroupMaintMode function)
GroupMaintMode -ScomServer "mmsscom01" -GroupDisplayName "SQL Server 2008 Computers" `
-DurationInMin 10  -Reason "ApplicationInstallation" -Comment "Scheduled weekly maintenance"

#--------End Sample Script----------------