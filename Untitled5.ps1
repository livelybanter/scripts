$users = "michael.tompkins@titlemax.com" # List of users to email your report to (separate by comma)
$fromemail = "ExchangeDiskMonitoring@titlemax.com"
$server = "prd-excas01.titlemax.com" 
$list = $args[0]  #This accepts the argument you add to your scheduled task for the list of servers. i.e. list.txt
$computers = get-content E:\scripts\list.txt #grab the names of the servers/computers to check from the list.txt file.
# Set free disk space threshold below in percent (default at 10%)
[decimal]$thresholdspace = 10
 
#assemble together all of the free disk space data from the list of servers and only include it if the percentage free is below the threshold we set above.
if({
$disk = Get-WMIObject  -ComputerName $computers Win32_LogicalDisk `
| select __SERVER, DriveType, VolumeName, Name, @{n='Size (Gb)' ;e={"{0:n2}" -f ($_.size/1gb)}},@{n='FreeSpace (Gb)';e={"{0:n2}" -f ($_.freespace/1gb)}}, @{n='PercentFree';e={"{0:n2}" -f ($_.freespace/$_.size*100)}} `
| Where-Object {$_.DriveType -eq 3 -and [decimal]$_.PercentFree -lt [decimal]$thresholdspace} `
| ConvertTo-HTML -fragment 
}
