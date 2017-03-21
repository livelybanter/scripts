# Parse Params:
[CmdletBinding()]
Param(
    [Parameter(
        Position=0,
        Mandatory=$False,
        HelpMessage="Full path of text file with list of machine names to put into maintenance mode:"
        )]
        [String]$TextPath = "C:\scripts\machineneames2.txt"
    )
    [Parameter(
        Position=1,
        Mandatory=$False,
        HelpMessage="How long should maintenance mode last (in minutes - default is 15)?"
        )]
        [ValidateRange(5,999)]
        [int]$Minutes = 30
    [Parameter(
        Position=2,
        Mandatory=$False,
        HelpMessage="Which SCOM server should this script connect to?"
        )]
        [string]$SCOMServer = prd-scomms01.titlemax.com
    [Parameter(
        Position=3,
        Mandatory=$False,
        HelpMessage="Add a comment about why you're doing this here:"
        )]
        [String]$Comment = "MaintenanceModeScript"
    
 
 
$MachineNames = Get-Content $TextPath
$MachineArray = New-Object System.Collections.ArrayList
 
foreach($Machine in $MachineNames)
{
    $MachineArray.Add($Machine) | Out-Null
}
 
# Connect to SCOM server:
$Session = New-PSSession -ComputerName $SCOMServer
$Session = Get-Pssession
 
# Run script remotely against SCOM server:
Invoke-Command -Session $Session -ScriptBlock {
    Param($MachineArray, $SCOMServer, $Minutes, $Comment)
     
    Write-Host $MachineArray.Count
 
    # Invoke OperationsManager module:
    Add-PSSnapin "Microsoft.EnterpriseManagement.OperationsManager.Client"
 
    # Create/connect to the DCSSCOM management group on SCOM server:
    Set-Location "OperationsManagerMonitoring::"
    $mgConn = New-ManagementGroupConnection -ConnectionString:$SCOMServer;
 
    # Connect to agent and set params for maintenance mode:
    $Agents = Get-Agent
 
    $QueriedAgents = @()
 
    for($i = 0; $i -lt $MachineArray.Count; $i++)
    {
        Write-Host "Working on: $($MachineArray[$i])" -ForegroundColor Cyan
        $AgentToAdd = $Agents | Where {$_.ComputerName –eq $MachineArray[$i]}
 
        if($AgentToAdd -eq $null)
        {
            Write-Host "Could not find agent for $($MachineArray[$i])" -ForegroundColor Red
            continue
        }
 
        $QueriedAgents += $AgentToAdd
    }
 
    foreach($Agent in $QueriedAgents)
    {
        $StartTime = [DateTime]::Now
        $EndTime = $StartTime.AddMinutes($Minutes)
        Start-SCOMMaintenanceMode -Instance $Agent.HostComputer -EndTime $EndTime -Reason "PlannedOther" -Comment $Comment
    }
 
} -ArgumentList $MachineArray, $SCOMServer, $Minutes, $Comment
 
 
# Cleanup!
Remove-PSSession -Session $Session