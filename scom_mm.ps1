Enter-PSSession -ComputerName prd-scomms01.titlemax.com -Credential $cred | Out-Null

#$Session = New-PSSession -ComputerName prd-scomms01.titlemax.com
#$Session = Get-Pssession

Import-Module -name OperationsManager
$servers = ('prd-trendcapp01.titlemax.com','prd-trendmgm02.titlemax.com')
$Time = ((Get-Date).AddMinutes(30))
$comment = "maintenance mode"
$reason = "PlannedOther"
<# -Reason Valid values are: PlannedOther,
UnplannedOther, PlannedHardwareMaintenance, UnplannedHardwareMaintenance, PlannedHardwareInstallation,
UnplannedHardwareInstallation, PlannedOperatingSystemReconfiguration, UnplannedOperatingSystemReconfiguration,
PlannedApplicationMaintenance, ApplicationInstallation, ApplicationUnresponsive, ApplicationUnstable,
SecurityIssue, LossOfNetworkConnectivity.
#> 
foreach ($server in $servers) 
{
$Instance = Get-SCOMClassInstance -Name $server.ToUpper()
Write-Host $Instance
Start-SCOMMaintenanceMode -Instance $Instance -EndTime $Time -Reason $reason -Comment $comment 
}